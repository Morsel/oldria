require_relative '../spec_helper'

describe Internship do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:internship, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Internship.create!(@valid_attributes)
  end
end

