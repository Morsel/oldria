require_relative '../spec_helper'

describe RestaurantNewsletter do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantNewsletter.create!(@valid_attributes)
  end
end
