require_relative '../spec_helper'

describe DefaultEmployment do
  before(:each) do
    @valid_attributes = {
      :employee_id => 1,
      :restaurant_role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    DefaultEmployment.create!(@valid_attributes)
  end
end

