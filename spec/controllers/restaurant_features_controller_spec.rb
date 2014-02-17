require_relative '../spec_helper'

describe RestaurantFeaturesController do

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @page = FactoryGirl.create(:restaurant_feature_page)
    @restaurant_feature = FactoryGirl.create(:restaurant_feature)
    @restaurant = FactoryGirl.create(:restaurant)
    Restaurant.stubs(:find => @restaurant)
  end

  it "index action should render index template" do
    get :index
    response.should be_redirect
  end

  it "add action" do
    get :add
    response.should be_success
  end

  it "edit_top" do
    get :edit_top
    response.should be_success
  end

  it "update_top" do
    get :update_top
    response.should be_redirect
  end

end
