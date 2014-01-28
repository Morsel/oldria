require_relative '../../spec_helper'

describe Admin::MetropolitanAreasController do
  integrate_views

  before(:each) do
    @metropolitan_area = FactoryGirl.create(:metropolitan_area)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all metropolitan_area as @metropolitan_area" do
      MetropolitanArea.stubs(:find).returns([@metropolitan_area])
      get :index
      assigns[:metros].should == [@metropolitan_area]
    end
  end

end
