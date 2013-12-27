require_relative '../spec_helper'

describe HqSlide do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:hq_slide)
  end

  it "should create a new instance given valid attributes" do
    HqSlide.create!(@valid_attributes)
  end
 
end	

