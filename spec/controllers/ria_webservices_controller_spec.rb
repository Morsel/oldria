require_relative '../spec_helper'

describe RiaWebservicesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET api_register" do
    it "api_register" do
      get :api_register
      response.should be_success
    end
    it "work if diner get on params" do
      get :api_register,:role=>"diner"
      response.should be_success
    end
  end

  describe "GET register" do
    it "work if get role media in params" do
      get :register,:role=>"media"
      response.should be_success
    end
    it "work if diner get on params" do
      get :register,:role=>"diner"
      response.should be_success
    end
  end

  describe "GET get_join_us_value" do
    it "Will get join_us_value" do
      get :get_join_us_value
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "GET create" do
    it "Will create" do
      get :create
      response.should be_success
    end
  end

  describe "POST save_session" do
    it "Will save_session" do
      post :save_session
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "GET create_psw_rst" do
    it "Will save_session" do
      post :create_psw_rst
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "GET soap_box_index" do
    it "Will soap_box_index" do
      get :soap_box_index
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "GET a_la_minute_answers" do
    it "Will a_la_minute_answers" do
      get :a_la_minute_answers
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "put bulk_update" do
    it "Will bulk_update" do
      put :bulk_update
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end

  describe "get menu_items" do
    it "Will menu_items" do
      @restaurant = FactoryGirl.create(:restaurant)
      get :menu_items,:restaurant_id=>@restaurant.id
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "post create_menu" do
    it "Will create_menu" do
      post :create_menu
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "get new_menu_item" do
    it "Will new_menu_item" do
      get :new_menu_item
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "post create_promotions" do
    it "Will create_promotions" do
      post :create_promotions
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "get get_promotion_type" do
    it "Will get_promotion_type" do
      get :get_promotion_type
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "post create_photo" do
    it "Will create_photo" do
      post :create_photo
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  
  
  describe "get show_photo" do
    it "Will show_photo" do
      get :show_photo
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  
 
  describe "post create_comments" do
    it "Will create_comments" do
      post :create_comments
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "get get_media_request" do
    it "Will get_media_request" do
      get :get_media_request
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "get get_qotds" do
    it "Will get_qotds" do
      get :get_qotds
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  

  describe "get get_newsfeed" do
    it "Will get_newsfeed" do
      get :get_newsfeed
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
      response.should be_success
    end
  end  



end 
