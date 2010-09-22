require 'spec/spec_helper'

describe Admin::RestaurantFeaturePagesController do

  before(:each) do
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeaturePage.expects(:new).with("name" => "test").returns(
          stub(:save => false, :name => "test"))
      post :create, :restaurant_feature_page => {:name => "test"}
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeaturePage.any_instance.stubs(:valid?).returns(true)
      RestaurantFeaturePage.expects(:new).with("name" => "test").returns(
          stub(:save => true, :name => "test"))
      post :create, :restaurant_feature_page => {:name => "test"}
      flash[:notice].should =~ /new page/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end
end