require 'spec/spec_helper'

describe Admin::RestaurantFeaturesController do

  let(:category) { stub(:id => 1, :name => "Category") }
  let(:params) { {"value" => "test", "restaurant_feature_category_id" => 1} }

  before(:each) do
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeature.expects(:new).with(params).returns(
          stub(:save => false, :value => "test"))
      post :create, :restaurant_feature => params
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeature.expects(:new).with(params).returns(
          stub(:save => true, :value => "test"))
      post :create, :restaurant_feature => params
      flash[:notice].should =~ /new feature/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end
end