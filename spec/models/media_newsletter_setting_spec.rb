require_relative '../spec_helper'

describe MediaNewsletterSetting do
	it { should belong_to :user }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:media_newsletter_setting)
  end

  it "should create a new instance given valid attributes" do
    MediaNewsletterSetting.create!(@valid_attributes)
  end

end	

