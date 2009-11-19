require File.dirname(__FILE__) + '/../spec_helper'

describe Employment do
  should_belong_to :employee, :class_name => "User"
  should_belong_to :restaurant
  should_belong_to :restaurant_role
  should_have_many :responsibilities
  should_have_many :subject_matters, :through => :responsibilities
  should_have_many :media_request_conversations
  should_have_many :media_requests, :through => :media_request_conversations

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
      Employment.first.employee.should == another_user
    end
  end
end
