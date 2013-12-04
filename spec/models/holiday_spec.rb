require_relative '../spec_helper'

describe Holiday do
  should_have_many :admin_holiday_reminders
  should_have_many :holiday_discussions
  should_have_many :restaurants, :through => :holiday_discussions
  
  it "should know how many have replied" do
    holiday = Factory(:holiday)
    holiday.reply_count.should == 0
  end
end
