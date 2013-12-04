require_relative '../spec_helper'

describe Competition do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:competition, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end

