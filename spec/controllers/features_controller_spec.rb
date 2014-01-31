require_relative '../spec_helper'

describe FeaturesController do
  integrate_views

  before(:each) do
    @restaurant_feature = FactoryGirl.create(:restaurant_feature)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all restaurant_feature as @restaurant_feature" do
      get :index
      response.header['Content-Type'].should include 'text/html'
    end
  end

  describe "GET show" do
    it "assigns show restaurant_feature as @restaurant_feature" do
      get :show,:id=> @restaurant_feature.id
      response.should render_template(:show)
    end
  end

  describe "GET auto_complete_featureskeywords" do
    it "it get auto_complete_featureskeywords" do
      get :auto_complete_featureskeywords
      response.header['Content-Type'].should include 'application/json'
    end
  end  

end   