require_relative '../spec_helper'

describe Holiday do
  it { should have_many :admin_holiday_reminders }
  it { should have_many :holiday_discussions }
  it { should have_many(:restaurants).through(:holiday_discussions) }
  it { should belong_to(:employment_search) }
  it { should accept_nested_attributes_for(:admin_holiday_reminders) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:date) }
  
  it "should know how many have replied" do
    holiday = FactoryGirl.create(:holiday)
    holiday.reply_count.should == 0
  end

  describe "#accepted_holiday_discussions" do
    it "should return the accepted holiday discussions" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.accepted_holiday_discussions.should ==  holiday.holiday_discussions.map(&:accepted)
    end 
  end

  describe "#accepted_holiday_discussion_restaurant_ids" do
    it "should return the accepted holiday discussions restaurant_ids" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.accepted_holiday_discussion_restaurant_ids.should ==  holiday.accepted_holiday_discussions.map(&:restaurant_id)
    end 
  end

  describe "#future_reminders" do
    it "should return the future_reminders" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.future_reminders.should ==  holiday.admin_holiday_reminders.all(:conditions => ['scheduled_at > ?', Time.now])
    end 
  end

  describe "#reminders_count" do
    it "should return the reminders_count" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.reminders_count.should ==  holiday.admin_holiday_reminders.size
    end 
  end

  describe "#reply_count" do
    it "should return the reply_count" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.reply_count.should ==  holiday.holiday_discussions.with_replies.count
    end 
  end

  describe "#next_reminder" do
    it "should return the next_reminder" do
    	holiday = FactoryGirl.create(:holiday)
      holiday.next_reminder.should ==  holiday.admin_holiday_reminders.first(:order => 'scheduled_at ASC')
    end 
  end

end
