require_relative '../spec_helper'

describe ProfileCuisine do
  before(:each) do
    @valid_attributes = {
      :profile_id => 1,
      :cuisine_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ProfileCuisine.create!(@valid_attributes)
  end
end

