require_relative '../spec_helper'

describe Mediafeed::MediaUsersController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:media_user)
  end

  describe "GET new" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "should render a form to /media_users" do
      get :new
      response.should have_selector("form", :action => "/mediafeed/media_users")
    end
  end

  describe "POST create" do
    it "create action should render new template when model is invalid" do
      User.any_instance.stubs(:save).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "should set make the new user a media user" do
      User.any_instance.stubs(:valid?).returns(true)
      post :create, :user => { :first_name => "Media", :last_name => "User", :username => "media", :email => "me@newsy.com", :password => "secret", :password_confirmation => "secret" }
      assigns[:user].should have_role(:media)
    end

    it "create action should redirect when model is valid" do
      UserMailer.signup.deliver.returns true
      User.any_instance.stubs(:valid?).returns(true)
      post :create, :user => { :first_name => "Media", :last_name => "User", :username => "media2", :email => "notme@newsy.com", :password => "secret", :password_confirmation => "secret" }
      response.should be_redirect
    end
  end

  describe "GET edit" do
    it "edit action should render edit template" do
      controller.stubs(:current_user).returns @user
      get :edit, :id => User.first
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    it "update action should redirect to root url when user is valid" do
      controller.stubs(:current_user).returns @user
      User.any_instance.stubs(:update_attributes).returns(true)
      put :update, :id => User.first
      response.should redirect_to(edit_mediafeed_media_user_path(User.first))
    end

    it "update action should render edit template when model is invalid" do
      controller.stubs(:current_user).returns @user
      User.any_instance.stubs(:update_attributes).returns(false)
      put :update, :id => User.first
      response.should render_template(:edit)
    end
  end
end
