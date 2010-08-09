require 'spec_helper'

describe QuestionRole do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :restaurant_role_ids => "value for restaurant_role_ids"
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionRole.create!(@valid_attributes)
  end
end
