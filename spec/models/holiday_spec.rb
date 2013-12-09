require_relative '../spec_helper'

describe Holiday do
  it { should have_many :admin_holiday_reminders }
  it { should have_many :holiday_discussions }
  it { should have_many(:restaurants).through(:holiday_discussions) }
  
  it "should know how many have replied" do
    holiday = FactoryGirl.create(:holiday)
    holiday.reply_count.should == 0
  end
end
