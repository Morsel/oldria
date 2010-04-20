require 'spec_helper'

describe HolidayDiscussionReminder do
  before(:each) do
    @valid_attributes = {
      :holiday_discussion_id => 1,
      :holiday_reminder_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    HolidayDiscussionReminder.create!(@valid_attributes)
  end
  
  it "should select current messages" do
    current_reminder = Factory.create(:holiday_reminder, :scheduled_at => Time.now.yesterday)
    current_hdr = Factory.create(:holiday_discussion_reminder, :holiday_reminder => current_reminder)
    tomorrow_reminder = Factory.create(:holiday_reminder, :scheduled_at => Time.now.tomorrow)
    tomorrow_hdr = Factory.create(:holiday_discussion_reminder, :holiday_reminder => tomorrow_reminder)
    HolidayDiscussionReminder.current.should == [current_hdr]
  end
end
