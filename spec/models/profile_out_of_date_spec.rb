require_relative '../spec_helper'

describe ProfileOutOfDate do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:profile_out_of_date)
  end

  it "should create a new instance given valid attributes" do
    ProfileOutOfDate.create!(@valid_attributes)
  end


end	

