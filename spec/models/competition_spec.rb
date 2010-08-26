require 'spec_helper'

describe Competition do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:competition)
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end
