require_relative '../spec_helper'

describe RestaurantFeatureItem do
  before(:each) do
    @valid_attributes = {
      :restaurant_feature_id => 1,
      :top_tag => 1,
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantFeatureItem.create!(@valid_attributes)
  end
end

