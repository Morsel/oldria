# == Schema Information
# Schema version: 20100426230131
#
# Table name: holiday_reminders
#
#  id           :integer         not null, primary key
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  holiday_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec/spec_helper'

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
