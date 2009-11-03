require File.dirname(__FILE__) + '/../spec_helper'

describe Employment do
  should_belong_to :employee, :class_name => "User"
  should_belong_to :restaurant
  should_validate_presence_of :employee_id
  should_validate_presence_of :restaurant_id
  
  describe "with employees" do
    before do
      @restaurant = Factory(:restaurant)
      @user = Factory(:user, :name => "Jimmy Dorian")
      @employment = Employment.create!(:employee_id => @user.id, :restaurant_id => @restaurant.id)
    end
    
    should_validate_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"
    
    it "#employee_name should return the employee's name" do
      @employment.employee_name.should eql("Jimmy Dorian")
    end
    
    it "should set employee through #employee_name" do
      another_user = Factory(:user, :name => "John Hammond")
      @employment.employee_name = "John Hammond"
      @employment.save
      Employment.first.employee.should == another_user
    end
  end
end
