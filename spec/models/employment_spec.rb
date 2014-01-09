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
  it { should belong_to(:employee).class_name("User") }
  it { should belong_to :restaurant }
  it { should belong_to :restaurant_role }
  it { should have_many :responsibilities }
  it { should have_many(:subject_matters).through(:responsibilities) }
  it { should have_many(:admin_conversations).class_name('Admin::Conversation').with_foreign_key('recipient_id') }
  it { should have_many(:admin_messages).through(:admin_conversations).class_name('Admin::Message') }
  it { should have_many(:admin_discussions).through(:restaurant) }
  it { should have_many(:holiday_conversations).with_foreign_key('recipient_id').dependent(:destroy) }
  it { should have_many(:holidays).through(:holiday_conversations) }
  it { should accept_nested_attributes_for :employee }
  it { should validate_presence_of :employee_id }
  it { should validate_presence_of :restaurant_id }

  describe "with employees" do
    before do
      @restaurant = FactoryGirl.create(:restaurant)
      @user = FactoryGirl.create(:user, :name => "Jimmy Dorian", :email => "dorian@rd.com")
      @employment = Employment.create!(:employee_id => @user.id, :restaurant_id => @restaurant.id)
    end
    # it do
    #   should validate_uniqueness_of(:employee_id).
    #     with_message('is already associated with that restaurant')
    # end
    #should_validate_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"

    it "#employee_name should return the employee's name" do
      @employment.employee_name.should eql("Jimmy Dorian")
    end

    it "#employee_email should return the employee's email" do
      @employment.employee_email.should eql("dorian@rd.com")
    end

    it "should set employee through #employee_email" do
      another_user = FactoryGirl.create(:user, :name => "John Hammond", :email => "hammond@rd.com")
      @employment.employee_email = "hammond@rd.com"
      @employment.save
      #CIS http://stackoverflow.com/questions/2009159/shoulda-test-validates-presence-of-on-update
      assert_equal false, @employment.valid?
      assert_equal("Role is required field", @employment.errors.get(:restaurant_role).join(''))
      # @employment.should be_valid
      @employment.employee.should == another_user
    end
  end

  describe "unique users" do
    before do
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:restaurant, :name => "What?", :manager => @user)
      FactoryGirl.create(:restaurant, :name => "Where?", :manager => @user)
    end

    it "should be able to find unique users, even if employed multiple places" do
      Employment.unique_users.length.should == 1
      Employment.unique_users.first.employee.should == @user
    end
  end

  describe "multiple selection search" do
    before do
      @restaurant = FactoryGirl.create(:restaurant)
    end

    it "should return the right items for the search" do
      Employment.search({"restaurant_id_equals_any" => [@restaurant.id, 1, 2, 3] }).all.should == @restaurant.employments
    end
  end

  it "should have many viewable media requests" do
    employment = FactoryGirl.create(:employment)
    employment.viewable_media_request_discussions.should == []
  end

  describe "public" do

    it "finds public employees" do
      public_employee = FactoryGirl.create(:employment, :public_profile => true)
      private_employee = FactoryGirl.create(:employment, :public_profile => false)
      Employment.public_profile_only.include?(public_employee).should == true
      Employment.public_profile_only.include?(private_employee).should == false
    end

  end

  describe "#employee_last_name" do
    it "should return the employee last name" do
      employment = FactoryGirl.build(:employment)
      employment.employee_last_name.should == employment.employee.last_name
    end 
  end

  describe "#restaurant_name" do
    it "should return the employee last name" do
      employment = FactoryGirl.build(:employment)
      employment.restaurant_name.should == employment.restaurant_name
    end 
  end

  describe "#name_and_restaurant" do
    it "should return the name and restaurant name" do
      employment = FactoryGirl.build(:employment)
      employment.name_and_restaurant.should ==  "#{employment.employee_name} (#{employment.restaurant_name})"
    end 
  end

  describe "#viewable_unread_media_request_discussions" do
    it "should return the viewable unread media request discussions" do
      employment = FactoryGirl.build(:employment)
      employment.viewable_unread_media_request_discussions.should ==  employment.restaurant.media_request_discussions.approved.select { |d| d.viewable_by?(employment) && !d.read_by?(employment.employee) }
    end 
  end

  describe "#current_viewable_admin_discussions" do
    it "should return the current viewable admin discussions" do
      employment = FactoryGirl.build(:employment)
      employment.current_viewable_admin_discussions.should == employment.viewable_admin_discussions.select { |discussion| Time.now >= discussion.scheduled_at }
    end 
  end

  describe "#current_viewable_trend_discussions" do
    it "should return the current viewable trend discussions" do
      employment = FactoryGirl.build(:employment)
      employment.current_viewable_trend_discussions.should == employment.viewable_trend_discussions.select { |discussion| Time.now >= discussion.scheduled_at  }
    end 
  end

  describe "#current_viewable_request_discussions" do
    it "should return the current viewable trend discussions" do
      employment = FactoryGirl.build(:employment)
      employment.current_viewable_request_discussions.should == employment.viewable_request_discussions.select { |discussion| Time.now >= discussion.scheduled_at }
    end 
  end

  describe "#viewable_admin_discussions" do
    it "should return the current viewable admin discussions" do
      employment = FactoryGirl.build(:employment)
      @all_discussions = employment.restaurant.admin_discussions.all({:include => :discussionable}.merge({})).select(&:discussionable)
      if employment.omniscient?
      all_discussions =  employment.restaurant.admin_discussions.all({:include => :discussionable}.merge({})).select(&:discussionable)
      else 
      all_discussions =  @all_discussions.select {|element| element.viewable_by? self }
      end   
      employment.viewable_admin_discussions.should == all_discussions
    end 
  end


  describe "#viewable_request_discussions" do
    it "should return the current viewable request discussions" do
      employment = FactoryGirl.build(:employment)
      @all_discussions = employment.admin_discussions.for_content_requests.select {|element| element.viewable_by? self }
      if employment.omniscient?
      all_discussions =  employment.admin_discussions.for_content_requests
      else 
      all_discussions =  @all_discussions
      end   
      employment.viewable_admin_discussions.should == all_discussions
    end 
  end


  describe "#viewable_trend_discussions" do
    it "should return the current viewable request discussions" do
      employment = FactoryGirl.build(:employment)
      @all_discussions = employment.admin_discussions.for_trends.select {|element| element.viewable_by? self }
      if employment.omniscient?
      all_discussions =  employment.admin_discussions.for_trends
      else 
      all_discussions =  @all_discussions
      end   
      employment.viewable_admin_discussions.should == all_discussions
    end 
  end


end


