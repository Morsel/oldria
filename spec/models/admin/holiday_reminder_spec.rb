require_relative '../../spec_helper'

describe Admin::HolidayReminder do
  should_belong_to :holiday

  before(:each) do
    @valid_attributes = Factory.attributes_for(:holiday_reminder)
  end

  it "should set a class-based title of 'Holiday Reminder'" do
    Admin::HolidayReminder.title.should == "Holiday Reminder"
  end

  it "should create a new instance given valid attributes" do
    holiday = Factory(:holiday)
    Admin::HolidayReminder.create!(@valid_attributes.merge(:holiday_id => holiday.id))
  end
    
end
