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

  describe "GET new" do
    it "assigns a new metropolitan_area as @metropolitan_area" do
      MetropolitanArea.stubs(:new).returns(@metropolitan_area)
      get :new
     response.should render_template(:new)
    end
  end  

  describe "GET create" do
    it "create action should render new template " do
      post :create
      response.should redirect_to(admin_metropolitan_areas_url)
    end
  end 
  
end
