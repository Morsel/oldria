require_relative '../spec_helper'

describe HolidayDiscussionReminder do
it { should belong_to(:holiday_discussion) }
it { should belong_to(:holiday_reminder).class_name('Admin::HolidayReminder') }

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

  describe "#inbox_title" do
    it "should return the inbox_title" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.inbox_title.should == holiday_discussion_reminder.holiday_reminder.inbox_title
    end 
  end

  describe "#email_title" do
    it "should return the email_title" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.email_title.should == holiday_discussion_reminder.holiday_reminder.email_title
    end 
  end

  describe "#holiday" do
    it "should return the holiday" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.holiday.should == holiday_discussion_reminder.holiday_discussion.holiday
    end 
  end

  describe "#restaurant" do
    it "should return the restaurant" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.restaurant.should == holiday_discussion_reminder.holiday_discussion.restaurant
    end 
  end

  describe "#message" do
    it "should return the message" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.message.should == holiday_discussion_reminder.holiday_reminder.message
    end 
  end

  describe "#scheduled_at" do
    it "should return the scheduled_at" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.scheduled_at.should == holiday_discussion_reminder.holiday_reminder.scheduled_at
    end 
  end

  describe "#comments_count" do
    it "should return the comments_count" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.comments_count.should == holiday_discussion_reminder.holiday_discussion.comments_count
    end 
  end

  describe "#employees" do
    it "should return the comments_count" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      #holiday_discussion_reminder.employees.should == holiday_discussion_reminder.restaurant ? holiday_discussion_reminder.restaurant.employees : []
    end 
  end

  describe "#comments" do
    it "should return the comments_count" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.comments.should == holiday_discussion_reminder.holiday_discussion.comments
    end 
  end

  describe "#recipients_can_reply?" do
    it "should return the recipients_can_reply?" do
      holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
      holiday_discussion_reminder.recipients_can_reply?.should == true
    end 
  end

end
