require_relative '../spec_helper'

describe RestaurantAnswer do
  before(:each) do
    @valid_attributes = {
      :restaurant_question_id => 1,
      :answer => "value for answer",
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantAnswer.create!(@valid_attributes)
  end
end

