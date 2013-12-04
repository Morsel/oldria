require_relative '../spec_helper'

describe Apprenticeship do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:apprenticeship)
    @valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Apprenticeship.create!(@valid_attributes)
  end
end

