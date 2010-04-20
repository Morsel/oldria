# == Schema Information
# Schema version: 20100303185000
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
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
