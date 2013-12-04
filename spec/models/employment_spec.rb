#
# Table name: employments
#
#  id                 :integer         not null, primary key
#  employee_id        :integer
#  restaurant_id      :integer
#  created_at         :datetime
#  updated_at         :datetime
#  restaurant_role_id :integer
#  omniscient         :boolean
#  primary            :boolean         default(FALSE)
#  public_profile     :boolean
#  position           :integer
#

require_relative '../spec_helper'

describe Employment do
  should_belong_to :employee, :class_name => "User"
  should_belong_to :restaurant
  should_belong_to :restaurant_role
  should_have_many :responsibilities
  should_have_many :subject_matters, :through => :responsibilities

  should_have_many :admin_conversations
  should_have_many :admin_messages, :through => :admin_conversations

  should_have_many :holiday_conversations
  should_have_many :holidays, :through => :holiday_conversations

  should_validate_presence_of :employee_id
  should_validate_presence_of :restaurant_id
  should_accept_nested_attributes_for :employee

  describe "with employees" do
    before do
      @restaurant = Factory(:restaurant)
      @user = Factory(:user, :name => "Jimmy Dorian", :email => "dorian@rd.com")
      @employment = Employment.create!(:employee_id => @user.id, :restaurant_id => @restaurant.id)
    end

    should_validate_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"

    it "#employee_name should return the employee's name" do
      @employment.employee_name.should eql("Jimmy Dorian")
    end

    it "#employee_email should return the employee's email" do
      @employment.employee_email.should eql("dorian@rd.com")
    end

    it "should set employee through #employee_email" do
      another_user = Factory(:user, :name => "John Hammond", :email => "hammond@rd.com")
      @employment.employee_email = "hammond@rd.com"
      @employment.save
      @employment.should be_valid
      @employment.employee.should == another_user
    end
  end

  describe "unique users" do
    before do
      @user = Factory(:user)
      Factory(:restaurant, :name => "What?", :manager => @user)
      Factory(:restaurant, :name => "Where?", :manager => @user)
    end

    it "should be able to find unique users, even if employed multiple places" do
      Employment.unique_users.length.should == 1
      Employment.unique_users.first.employee.should == @user
    end
  end

  describe "multiple selection search" do
    before do
      @restaurant = Factory(:restaurant)
    end

    it "should return the right items for the search" do
      Employment.search({"restaurant_id_equals_any" => [@restaurant.id, 1, 2, 3] }).all.should == @restaurant.employments
    end
  end

  it "should have many viewable media requests" do
    employment = Factory(:employment)
    employment.viewable_media_request_discussions.should == []
  end

  describe "public" do

    it "finds public employees" do
      public_employee = Factory(:employment, :public_profile => true)
      private_employee = Factory(:employment, :public_profile => false)
      Employment.public_profile_only.include?(public_employee).should == true
      Employment.public_profile_only.include?(private_employee).should == false
    end

  end
end



