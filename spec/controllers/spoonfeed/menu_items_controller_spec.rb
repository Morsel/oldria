require_relative '../../spec_helper'

describe Spoonfeed::MenuItemsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "this condition works if keyword is present" do
      get :index,:keyword=>"test"
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions => ["otm_keywords.name = ?", "test"], :order => "menu_items.created_at DESC")
      assigns[:menu_items].should == @menu_items
      response.should render_template('index')
    end

    it "this condition works if keyword is not present" do
      get :index
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC")
      assigns[:menu_items].should == @menu_items
      response.should render_template('index')
    end
  end

  describe "GET show" do
    it "this condition works for show" do
    	@restaurant = FactoryGirl.create(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
      @valid_attributes = FactoryGirl.attributes_for(:menu_item, :otm_keywords => [FactoryGirl.create(:otm_keyword)], :restaurant => @restaurant)
      MenuItem.any_instance.stubs(:restaurant).returns(@restaurant)
      test_photo = ActionDispatch::Http::UploadedFile.new({
	      :filename => 'index.jpeg',
	      :type => 'image/jpeg',
	      :tempfile => File.new("#{Rails.root}/spec/fixtures/index.jpeg")
      })
     @valid_attributes[:photo] = test_photo
     @menu_item = MenuItem.create!(@valid_attributes)
      get :show,:id=>@menu_item.id
      @menu_item = MenuItem.find(:first,:conditions=>["menu_items.id= ?", @menu_item.id]) 
      @restaurant = @menu_item.restaurant
      assigns[:menu_items].should == @menu_items
      assigns[:restaurant].should == @restaurant
      response.should render_template('show')
    end
  end

  describe "GET verify_restaurant_activation" do
    it "this condition works for verify_restaurant_activation" do
    	@restaurant = FactoryGirl.create(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
      @valid_attributes = FactoryGirl.attributes_for(:menu_item, :otm_keywords => [FactoryGirl.create(:otm_keyword)], :restaurant => @restaurant)
      MenuItem.any_instance.stubs(:restaurant).returns(@restaurant)
      test_photo = ActionDispatch::Http::UploadedFile.new({
	      :filename => 'index.jpeg',
	      :type => 'image/jpeg',
	      :tempfile => File.new("#{Rails.root}/spec/fixtures/index.jpeg")
      })
    @valid_attributes[:photo] = test_photo
    @menu_item = MenuItem.create!(@valid_attributes)
      get :verify_restaurant_activation,:id=>@menu_item.id
  	  @menu_item = MenuItem.find(@menu_item.id)   
  	  assigns[:menu_item].should == @menu_item    
      response.should be_success
    end
  end


end
