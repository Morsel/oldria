require_relative '../spec_helper'

describe UsersController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all user as @user" do
      get :index
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
    end
  end

  describe "GET show" do
    it "show" do
      get :show,:id=>@user.id
      response.should render_template(:show)
    end
  end

  describe "GET resume" do
    it "resume" do
      get :resume,:id=>@user.id
      response.should render_template(:resume)
    end
  end

  describe "GET edit" do
    it "edit" do
      get :edit,:id=>@user.id
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end

  describe "GET confirm" do
    it "confirm" do
      get :confirm,:id=>@user.id
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
  end

  describe "GET save_confirmation" do
    it "save_confirmation" do
      get :save_confirmation,:id=>@user.id,:user_id=>@user.id
      response.should render_template(:action=> "new")
    end
  end

  describe "GET resend_confirmation" do
    it "resend_confirmation" do
      user = FactoryGirl.create(:user,:perishable_token=>'fffdfdfddfd')
      post :resend_confirmation,:id=>user.id,:email=>user.email
      flash[:notice].should_not be_nil
      response.should redirect_to(admin_users_path)
    end
  end

  describe "GET remove_twitter" do
    it "remove_twitter" do
      get :remove_twitter,:id=>@user.id
      flash[:message].should_not be_nil
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end

  describe "GET remove_avatar" do
    it "remove_avatar" do
      get :remove_avatar,:id=>@user.id
      flash[:message].should_not be_nil
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end

  describe "GET fb_deauth" do
    it "fb_deauth" do
      get :fb_deauth,:id=>@user.id
      flash[:notice].should_not be_nil
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end

  describe "GET fb_connect" do
    it "fb_connect" do
      get :fb_connect,:id=>@user.id
      response.should be_redirect
    end
  end

  describe "GET fb_page_auth" do
    it "fb_page_auth" do
      get :fb_page_auth,:id=>@user.id
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end  

  describe "GET upload" do
    it "upload" do
      get :upload,:id=>@user.id
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
    end
  end  

  describe "GET edit_newsletters" do
    it "edit_newsletters" do
      get :edit_newsletters,:id=>@user.id
      response.should render_template(:edit_newsletters)
    end
  end  

  describe "GET new_james_beard_region" do
    it "new_james_beard_region" do
      james_beard_region = FactoryGirl.create(:james_beard_region)
      get :new_james_beard_region,:id=>@user.id,:user_id=>@user.id
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
    end
  end  


end
