require 'spec/spec_helper'

describe Admin::HolidayRemindersController do
  integrate_views

  before(:each) do
    fake_admin_user
    Factory(:holiday_reminder)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => 1
      response.should be_success
    end
  end
end
