require_relative '../spec_helper'

describe SoapboxSlide do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:soapbox_slide)
  end

  it "should create a new instance given valid attributes" do
    SoapboxSlide.create!(@valid_attributes)
  end
end

