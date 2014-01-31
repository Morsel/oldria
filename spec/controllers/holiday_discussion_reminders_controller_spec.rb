require_relative '../spec_helper'

describe HolidayDiscussionRemindersController do
  integrate_views

  before(:each) do
  	@holiday_discussion_reminder = FactoryGirl.create(:holiday_discussion_reminder)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "show action should render show template" do
    get :show,:id=>@holiday_discussion_reminder.id
    response.should redirect_to(@holiday_discussion_reminder.holiday_discussion)
  end

  it "read action should render read template" do
    get :read,:id=>@holiday_discussion_reminder.id
    response.should be_success
  end

end
