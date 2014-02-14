require_relative '../spec_helper'

describe RestaurantFactSheetsController do
  integrate_views
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @restaurant = FactoryGirl.build(:restaurant)
    @restaurant.save(:validate => false)
    @fact_sheet = FactoryGirl.create(:restaurant_fact_sheet,:restaurant_id=>@restaurant_id)
  end

  it "show action should render show template" do
    get :show,:restaurant_id=>@restaurant.id,:id => RestaurantFactSheet.first
    response.should render_template(:show)
  end

  it "edit action should render edit template" do
    get :edit, :id => RestaurantFactSheet.first,:restaurant_id=>@restaurant.id
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    RestaurantFactSheet.any_instance.stubs(:valid?).returns(false)
    put :update, :id => RestaurantFactSheet.first,:restaurant_id=>@restaurant.id
    response.should render_template(:edit)
  end




end
