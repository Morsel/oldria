require_relative '../../spec_helper'

describe Admin::HolidayReminder do
  it { should belong_to :holiday }
  it { should have_many(:holiday_discussion_reminders) }
  it { should have_many(:holiday_discussions).through(:holiday_discussion_reminders) }
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:holiday_reminder)
  end

  it "should set a class-based title of 'Holiday Reminder'" do
    Admin::HolidayReminder.title.should == "Holiday Reminder"
  end

  it "should create a new instance given valid attributes" do
    holiday = FactoryGirl.create(:holiday)
    Admin::HolidayReminder.create!(@valid_attributes.merge(:holiday_id => holiday.id))
  end
  
  describe ".current" do
    it "should return current" do
      holiday_reminder = FactoryGirl.create(:holiday_reminder)
      Admin::HolidayReminder.current.should == Admin::HolidayReminder.find(:all,:conditions=>['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now])
    end
  end

  describe ".title" do
    it "should return title" do
      holiday_reminder = FactoryGirl.create(:holiday_reminder)
      Admin::HolidayReminder.title.should ==  "Holiday Reminder"
    end
  end
  
  describe "#inbox_title" do
    it "should return inbox_title" do
      holiday_reminder = FactoryGirl.create(:holiday_reminder)
      holiday_reminder.inbox_title.should == holiday_reminder.holiday.name
    end
  end    

  describe "#email_title" do
    it "should return email_title" do
      holiday_reminder = FactoryGirl.create(:holiday_reminder)
     holiday_reminder.email_title.should ==   "Reminder for #{holiday_reminder.inbox_title}"
    end
  end    


end
