require 'spec_helper'

describe MenuItemsController do
  
  before(:each) do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
    @restaurant = Factory(:restaurant, :manager => @user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :restaurant_id => @restaurant.id
      response.should be_success
    end
    
    it "should display the existing menu items" do
      Factory(:menu_item, :restaurant => @restaurant)
      get 'index', :restaurant_id => @restaurant.id
      assigns[:menu_items].should_not be_blank
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :restaurant_id => @restaurant.id
      response.should be_success
    end
  end

end
