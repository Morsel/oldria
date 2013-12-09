require_relative '../spec_helper'

describe Competition do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:competition)
  	@valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end

