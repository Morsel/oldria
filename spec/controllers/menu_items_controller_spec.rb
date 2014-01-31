require_relative '../spec_helper'
include ActionDispatch::TestProcess
describe MenuItemsController do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@user)
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    @test_photo = ActionDispatch::Http::UploadedFile.new({
      :filename => 'index.jpeg',
      :type => 'image/jpeg',
      :tempfile => File.new("#{Rails.root}/spec/fixtures/index.jpeg")
    })
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :restaurant_id => @restaurant.id
      response.should be_success
    end
    
    it "should display the existing menu items" do 
      FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
      get 'index', :restaurant_id => @restaurant.id
      assigns[:menu_items].should_not be_blank
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
      get 'edit', { :restaurant_id => @restaurant.id, :id => item.id }
      response.should be_success
    end
  end

  describe "update" do
    it "should update the menu item" do
      item = FactoryGirl.create(:menu_item, :name => "Old name", :restaurant => @restaurant,:photo=>@test_photo)
      put :update, :menu_item => { :name => "New name" }, :restaurant_id => @restaurant.id, :id => item.id
      response.should be_redirect
      MenuItem.find(item.id).name.should == "New name"
    end
  end
  
  describe "destroy" do
    it "should destroy the menu item" do
      item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
      delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
      response.should be_redirect
      MenuItem.all.should be_empty
    end
  end

  describe "facebook_post" do
    it "should get facebook_post" do
      item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
      delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
      response.should render_template(:action=> "index")
    end
  end

  describe "get_keywords" do
    it "should get get_keywords" do
      item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
      delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
      response.header['Content-Type'].should include 'text/html'
    end
  end


end
