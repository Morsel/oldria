require_relative '../spec_helper'

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
      item = Factory(:menu_item, :restaurant => @restaurant)
      get 'edit', { :restaurant_id => @restaurant.id, :id => item.id }
      response.should be_success
    end
  end

  describe "update" do
    it "should update the menu item" do
      item = Factory(:menu_item, :name => "Old name", :restaurant => @restaurant)
      put :update, :menu_item => { :name => "New name" }, :restaurant_id => @restaurant.id, :id => item.id
      response.should be_redirect
      MenuItem.find(item.id).name.should == "New name"
    end
  end
  
  describe "destroy" do
    it "should destroy the menu item" do
      item = Factory(:menu_item, :restaurant => @restaurant)
      delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
      response.should be_redirect
      MenuItem.all.should be_empty
    end
  end

end
