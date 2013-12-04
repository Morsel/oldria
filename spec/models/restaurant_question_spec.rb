require_relative '../spec_helper'

describe RestaurantQuestion do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :position => 1,
      :chapter_id => 1,
      :pages_description => "value for pages_description"
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantQuestion.create!(@valid_attributes)
  end
end

