require_relative '../spec_helper'

describe Stage do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:stage, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Stage.create!(@valid_attributes)
  end
end


