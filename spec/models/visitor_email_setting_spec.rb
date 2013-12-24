require_relative '../spec_helper'

describe VisitorEmailSetting do
	it { should belong_to :restaurant }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:visitor_email_setting)
  end

  it "should create a new instance given valid attributes" do
    VisitorEmailSetting.create!(@valid_attributes)
  end

  it "should be required to have a email frequency day if  it's a email frequency day is Daily" do
    params = FactoryGirl.attributes_for(:visitor_email_setting, :email_frequency => "Daily")
    visitor_email_setting = VisitorEmailSetting.create(params)
    visitor_email_setting.should have(0).error_on(:email_frequency)
  end

  it "should be required to have a email frequency day" do
    params = FactoryGirl.attributes_for(:visitor_email_setting, :email_frequency => nil)
    visitor_email_setting = VisitorEmailSetting.create(params)
    visitor_email_setting.should have(1).error_on(:email_frequency)
  end
 
	it "is invalid without a email frequency" do
	 	FactoryGirl.build(:visitor_email_setting, email_frequency: nil).should_not be_valid 
	end 
  
  it "is invalid without inclusion of email frequency" do
    FactoryGirl.build(:visitor_email_setting, email_frequency: nil).should ensure_inclusion_of(:email_frequency).in_array(["Daily","Weekly", "Biweekly", "Monthly"])
  end   


end	

