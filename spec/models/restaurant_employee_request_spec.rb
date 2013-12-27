require_relative '../spec_helper'

describe RestaurantEmployeeRequest do
	it { should belong_to :employee }
	it { should belong_to :restaurant }
  it do
    should validate_uniqueness_of(:employee_id).scoped_to(:restaurant_id).
      with_message('Request already been sent.')
  end
 	
  before(:each) do
    @valid_attributes = {
      :employee_id => 1,
      :restaurant_id => 1
    }
     end

  it "should create a new instance given valid attributes" do
    RestaurantEmployeeRequest.create!(@valid_attributes)
  end

  it "is invalid without a employee id" do
	 	FactoryGirl.build(:restaurant_employee_request, employee_id: nil).should_not be_valid 
	end 
  
 	it "is invalid without a restaurant id" do
	 	FactoryGirl.build(:restaurant_employee_request, restaurant_id: nil).should_not be_valid 
	end 
  
end 
