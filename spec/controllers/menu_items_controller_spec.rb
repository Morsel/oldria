require_relative '../spec_helper'
include ActionDispatch::TestProcess
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

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
    @menu_item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :restaurant_id => @restaurant.id
      response.should be_success
    end
  end   
    
  describe "GET new" do
    it "assigns a new menu_item as @menu_item" do
      get :new, :restaurant_id => @restaurant.id
      response.should be_success
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        MenuItem.stubs(:new).returns(@menu_item)
        MenuItem.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created menu_item as @menu_item" do
        post :create, :menu_item => {}, :restaurant_id => @restaurant.id
        assigns[:menu_item].should equal(@menu_item)
      end

      it "redirects to the created menu_item" do
        post :create, :menu_item => {}, :restaurant_id => @restaurant.id
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        MenuItem.any_instance.stubs(:save).returns(false)
        MenuItem.stubs(:new).returns(@menu_item)
      end

      it "assigns a newly created but unsaved menu_item as @menu_item" do
        post :create, :menu_item => {:these => 'params'}, :restaurant_id => @restaurant.id
        assigns[:menu_item].should equal(@menu_item)
      end

      it "re-renders the 'new' template" do
        post :create, :menu_item => {}, :restaurant_id => @restaurant.id
        response.should render_template(:action=> "new")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested menu_item as @menu_item" do
      MenuItem.stubs(:find).returns(@menu_item)
      get :edit, :id => MenuItem.first, :restaurant_id => @restaurant.id
      response.should be_success
    end
  end

  it "update" do
    put :update, :id => MenuItem.first, :restaurant_id => @restaurant.id
  end

  describe "destroy" do
    it "should destroy the menu item" do
      delete :destroy, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should be_redirect
      MenuItem.all.should be_empty
    end
  end

  describe "facebook_post" do
    it "facebook_post" do
      get :facebook_post, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should redirect_to :action => :index
    end
  end

  describe "get_keywords" do
    it "get_keywords" do
      get :get_keywords, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should be_success
    end
  end    

  describe "add_keywords" do
    # it "add_keywords" 
    #   get :add_keywords, :id => @menu_item.id, :restaurant_id => @restaurant.id
    #   response.should be_success
    # end
  end

  describe "details" do
    it "details" do
      get :details, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should be_success
    end
  end

  describe "show" do
    it "show" do
      get :show, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should be_success
    end
  end  

  describe "verify_restaurant_activation" do
    it "verify_restaurant_activation" do
      get :verify_restaurant_activation, :id => @menu_item.id, :restaurant_id => @restaurant.id
      response.should redirect_to(soapbox_menu_items)
    end
  end


end  

  # describe "PUT update" do

  #   describe "with valid params" do
  #     before(:each) do
  #       MenuItem.stubs(:find).returns(@menu_item)
  #       MenuItem.any_instance.stubs(:update_attributes).returns(true)
  #     end

  #     it "updates the requested menu_item" do
  #       MenuItem.expects(:find).with("37").returns(@menu_item)
  #       put :update, :id => "37", :menu_item => {:these => 'params'}, :restaurant_id => @restaurant.id
  #     end

  #     it "assigns the requested menu_item as @menu_item" do
  #       MenuItem.stubs(:find).returns(@menu_item)
  #       put :update, :id => "1", :restaurant_id => @restaurant.id
  #       assigns[:menu_item].should equal(@menu_item)
  #     end

  #     it "redirects to all menu_item" do
  #       MenuItem.stubs(:find).returns(@menu_item)
  #       put :update, :id => "1", :restaurant_id => @restaurant.id
  #       response.should redirect_to :action => :index
  #     end
  #   end

  #   describe "with invalid params" do
  #     before(:each) do
  #       MenuItem.stubs(:find).returns(@menu_item)
  #       MenuItem.any_instance.stubs(:update_attributes).returns(false)
  #     end

  #     it "updates the requested menu_item" do
  #       MenuItem.expects(:find).with("37").returns(@menu_item)
  #       put :update, :id => "37", :menu_item => {:these => 'params'}, :restaurant_id => @restaurant.id
  #     end

  #     it "assigns the menu_item as @menu_item" do
  #       put :update, :id => "1", :restaurant_id => @restaurant.id
  #       assigns[:menu_item].should equal(@menu_item)
  #     end

  #     it "re-renders the 'edit' template" do
  #       MenuItem.stubs(:find).returns(@menu_item)
  #       put :update, :id => "1", :restaurant_id => @restaurant.id
  #       response.should render_template(:action=> "edit")
  #     end
  #   end
  # end


  #   it "should display the existing menu items" do 
  #     FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  #     get 'index', :restaurant_id => @restaurant.id
  #     assigns[:menu_items].should_not be_blank
  #   end
  # end

  # describe "GET 'edit'" do
  #   it "should be successful" do
  #     item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  #     get 'edit', { :restaurant_id => @restaurant.id, :id => item.id }
  #     response.should be_success
  #   end
  # end

  # describe "update" do
  #   it "should update the menu item" do
  #     item = FactoryGirl.create(:menu_item, :name => "Old name", :restaurant => @restaurant,:photo=>@test_photo)
  #     put :update, :menu_item => { :name => "New name" }, :restaurant_id => @restaurant.id, :id => item.id
  #     response.should be_redirect
  #     MenuItem.find(item.id).name.should == "New name"
  #   end
  # end
  
  # describe "destroy" do
  #   it "should destroy the menu item" do
  #     item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  #     delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
  #     response.should be_redirect
  #     MenuItem.all.should be_empty
  #   end
  # end

  # describe "facebook_post" do
  #   it "should get facebook_post" do
  #     item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  #     delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
  #     response.should render_template(:action=> "index")
  #   end
  # end

  # describe "get_keywords" do
  #   it "should get get_keywords" do
  #     item = FactoryGirl.create(:menu_item, :restaurant => @restaurant,:photo=>@test_photo)
  #     delete :destroy, :id => item.id, :restaurant_id => @restaurant.id
  #     response.header['Content-Type'].should include 'text/html'
  #   end
  # end



