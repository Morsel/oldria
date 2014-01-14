require_relative '../spec_helper'

describe PromotionType do
  it { should have_many(:promotions) }	
  it { should have_many(:newsfeed_promotion_types) }	
  it { should have_many(:users).through(:newsfeed_promotion_types) }  

  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    PromotionType.create!(@valid_attributes)
  end
end

