require_relative '../spec_helper'

describe NewsletterSetting do
	it { should belong_to :restaurant }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:newsletter_setting)
  end

  it "should create a new instance given valid attributes" do
    NewsletterSetting.create!(@valid_attributes)
  end

end	

