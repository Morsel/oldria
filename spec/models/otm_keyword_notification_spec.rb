require_relative '../spec_helper'

describe OtmKeywordNotification do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:otm_keyword_notification)
  end

  it "should create a new instance given valid attributes" do
    OtmKeywordNotification.create!(@valid_attributes)
  end

end	

