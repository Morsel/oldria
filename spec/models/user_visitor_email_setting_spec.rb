require_relative '../spec_helper'

describe UserVisitorEmailSetting do
	it { should belong_to :user }

	before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:user_visitor_email_setting)
  end

  it "should create a new instance given valid attributes" do
    UserVisitorEmailSetting.create!(@valid_attributes)
  end

  it "is invalid without a email frequency" do
	 	FactoryGirl.build(:user_visitor_email_setting, email_frequency: nil).should_not be_valid 
	end 

end
