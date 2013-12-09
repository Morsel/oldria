require_relative '../spec_helper'

describe Stage do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:stage)
    @valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Stage.create!(@valid_attributes)
  end
end


