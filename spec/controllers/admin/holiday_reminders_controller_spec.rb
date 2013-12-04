require_relative '../spec_helper'

describe Admin::HolidayRemindersController do
  integrate_views

  before(:each) do
    fake_admin_user
    @holiday = Factory(:holiday)
    @holiday_reminder = Factory(:holiday_reminder, :holiday => @holiday)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :holiday_id => @holiday.id
      response.should be_success
    end    
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => @holiday_reminder 
      response.should be_success
    end
  end
  
  it "should set up holiday reminders for all selected restaurants" do
    holiday = Factory(:holiday)
    Factory(:holiday_discussion, :holiday => holiday)
    reminder = Factory(:holiday_reminder, :holiday => holiday)
    Admin::HolidayReminder.expects(:new).with(reminder.attributes).returns(reminder)
    reminder.expects(:holiday_discussions=).with(reminder.holiday.holiday_discussions)
    post :create, :admin_holiday_reminder => reminder.attributes
  end
  
  it "should only send a holiday reminder to restaurants that haven't replied acceptably" do
    holiday = Factory(:holiday)
    Factory(:holiday_discussion, :holiday => holiday, :accepted => false)
    Factory(:holiday_discussion, :holiday => holiday, :accepted => true)
    reminder = Factory(:holiday_reminder, :holiday => holiday)
    Admin::HolidayReminder.expects(:new).with(reminder.attributes).returns(reminder)
    reminder.expects(:holiday_discussions=).with(reminder.holiday.holiday_discussions.needs_reply)
    post :create, :admin_holiday_reminder => reminder.attributes
  end
    
end
