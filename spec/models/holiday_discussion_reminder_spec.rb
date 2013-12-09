require_relative '../spec_helper'

describe HolidayDiscussionReminder do
  before(:each) do
    @valid_attributes = {
      :holiday_discussion_id => 1,
      :holiday_reminder_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    HolidayDiscussionReminder.any_instance.stubs(:notify_recipients).returns(true)
    HolidayDiscussionReminder.create!(@valid_attributes)
  end
  
  it "should select current messages" do
    FactoryGirl.create(:employment_search)
    current_reminder = FactoryGirl.create(:holiday_reminder, :scheduled_at => Time.now.yesterday)
    current_hdr = FactoryGirl.create(:holiday_discussion_reminder, :holiday_reminder => current_reminder)
    tomorrow_reminder = FactoryGirl.create(:holiday_reminder, :scheduled_at => Time.now.tomorrow)
    tomorrow_hdr = FactoryGirl.create(:holiday_discussion_reminder, :holiday_reminder => tomorrow_reminder)
    HolidayDiscussionReminder.current.should == [current_hdr]
  end
  
  it "should send a email notification to discussion recipients" do
    user = FactoryGirl.create(:user, :prefers_receive_email_notifications => true)
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:employment, :restaurant => restaurant, :employee => user)
    discussion = FactoryGirl.create(:holiday_discussion, :restaurant => restaurant)
    reminder = FactoryGirl.create(:holiday_reminder, :scheduled_at => Time.now)
    discussion_reminder = HolidayDiscussionReminder.new(:holiday_discussion => discussion, :holiday_reminder => reminder)
    discussion_reminder.expects(:send_at).with(reminder.scheduled_at, :queued_message_sending)
    discussion_reminder.save!
  end
end
