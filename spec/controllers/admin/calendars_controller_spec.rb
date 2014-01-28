require_relative '../../spec_helper'

describe Admin::CalendarsController do

 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


  describe "GET index" do
    it "work in date is present" do
    	@event = FactoryGirl.create(:event)
      get :index,:date=>@event.start_at
    end
    it "work in category is present" do
    	@event = FactoryGirl.create(:event)
      get :index,:category=>@event.category
    end
    it "work in category is present" do
      @event = FactoryGirl.create(:event)
      get :index
      response.should render_template('calendars/index')
    end

  end
end
