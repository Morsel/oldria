require_relative '../spec_helper'

describe Topic do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:topic)
  end

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end
end


