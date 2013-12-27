require_relative '../spec_helper'

describe PushNotificationUser do
	it { should belong_to :user }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:push_notification_user)
  end

  it "should create a new instance given valid attributes" do
    PushNotificationUser.create!(@valid_attributes)
  end

	it "is invalid without a email frequency" do
	 	FactoryGirl.build(:push_notification_user, uniq_device_key: nil).should_not be_valid 
	end 
  
  it "is invalid without a email frequency" do
    FactoryGirl.build(:push_notification_user, device_tocken: nil).should_not be_valid 
  end 
  


end	

