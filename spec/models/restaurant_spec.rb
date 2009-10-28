require File.dirname(__FILE__) + '/../spec_helper'

describe Restaurant do
  should_belong_to :manager, :class_name => "User"
  should_belong_to :metropolitan_area
  should_belong_to :james_beard_region
  should_belong_to :cuisine

  it "should belong to a manager (user)" do
    user = Factory(:user)
    restaurant = Restaurant.create(:name => "Moon Lodge", :manager => user)
    restaurant.save 
    restaurant2 = Restaurant.find(restaurant.id)
    restaurant2.manager.should == user
  end
end
