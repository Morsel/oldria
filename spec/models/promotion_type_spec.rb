require_relative '../spec_helper'

describe PromotionType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    PromotionType.create!(@valid_attributes)
  end
end

