require_relative '../spec_helper'

describe HolidayDiscussionsController do
  integrate_views

  before(:each) do
    @holiday_discussion = FactoryGirl.create(:holiday_discussion)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "show action should render show template" do
    get :show,:id=>@holiday_discussion.id
    response.should render_template(:show)
  end

  it "update action should render edit template when model is invalid" do
    HolidayDiscussion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => HolidayDiscussion.first
    response.should redirect_to (admin_holiday_path(@holiday_discussion.holiday))
  end

  it "Read" do
    put :read, :id => HolidayDiscussion.first
    response.should be_success
  end


end
