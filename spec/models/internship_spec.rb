require_relative '../spec_helper'

describe Internship do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:internship)
    @valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Internship.create!(@valid_attributes)
  end
end

