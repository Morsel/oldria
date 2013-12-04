require_relative '../spec_helper'

describe OtmKeyword do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :category => "value for category"
    }
  end

  it "should create a new instance given valid attributes" do
    OtmKeyword.create!(@valid_attributes)
  end
end

