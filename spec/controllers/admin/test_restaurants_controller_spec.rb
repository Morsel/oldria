require_relative '../../spec_helper'

describe Admin::TestRestaurantsController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "GET index" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET active" do
    it "GET active" do
      restaurant = FactoryGirl.create(:restaurant,:deleted_at=>'2011-02-15 13:34:54')
      get :active,:id=>restaurant.id
      response.should redirect_to(edit_admin_restaurant_path(restaurant)) 
    end
  end




end