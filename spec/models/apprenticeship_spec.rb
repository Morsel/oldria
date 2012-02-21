require 'spec_helper'

describe Apprenticeship do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:apprenticeship, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Apprenticeship.create!(@valid_attributes)
  end
end

