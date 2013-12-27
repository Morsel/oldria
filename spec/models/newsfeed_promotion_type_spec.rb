require_relative '../spec_helper'

describe NewsfeedPromotionType do
	it { should belong_to(:promotion_type) }
	it { should belong_to(:user) }

  
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:newsfeed_promotion_type)
  end

  it "should create a new instance given valid attributes" do
    NewsfeedPromotionType.create!(@valid_attributes)
  end

end	

