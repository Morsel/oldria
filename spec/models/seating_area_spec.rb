require_relative '../spec_helper'

describe SeatingArea do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:seating_area)
  end

  it "should create a new instance given valid attributes" do
    SeatingArea.create!(@valid_attributes)
  end
end 