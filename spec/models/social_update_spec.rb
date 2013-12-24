require_relative '../spec_helper'

describe SocialUpdate do
	it { should belong_to :restaurant }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:social_update)
  end

  it "should create a new instance given valid attributes" do
    SocialUpdate.create!(@valid_attributes)
  end
end 