require 'spec/spec_helper'

describe Admin::RestaurantFeatureCategoriesController do

  let(:page) { stub(:id => 1, :name => "Page") }
  let(:params) { {"name" => "test", "restaurant_feature_page_id" => 1} }

  before(:each) do
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeatureCategory.expects(:new).with(params).returns(
          stub(:save => false, :name => "test"))
      post :create, :restaurant_feature_category => params
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeatureCategory.expects(:new).with(params).returns(
          stub(:save => true, :name => "test"))
      post :create, :restaurant_feature_category => params
      flash[:notice].should =~ /new category/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end
end