require_relative '../spec_helper'

describe RestaurantTopic do
  before(:each) do
    @valid_attributes = {
      :title => "My Title",
      :description => "A description"
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantTopic.create!(@valid_attributes)
  end
end

