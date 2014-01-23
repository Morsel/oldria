require_relative '../../spec_helper'

describe Mediafeed::MediafeedController do

  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_user).returns(true)
  end

  it "should send a request for information" do
    @sender = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@sender)
    
    restaurant = FactoryGirl.create(:restaurant)
    UserMailer.expects(:message_notification)
    post :request_information, :user_id => restaurant.media_contact_id, :request_type => "Twitter", :request_title => "Twitter message here..."
    DirectMessage.count.should == 1
  end

  describe "GET index" do
    it "assigns all index as @index" do
      get :index
      response.should redirect_to(root_url(:subdomain => "spoonfeed"))
    end
  end

  describe "GET login" do
    it "assigns all index as @login" do
      get :login
      response.should redirect_to(login_url(:subdomain => "spoonfeed"))
    end
  end

  describe "GET directory" do
    it "assigns all index as @directory" do
    	@use_search = true
    	@users = User.in_soapbox_directory.all(:order => "users.last_name")
      get :directory
      assigns[:users].should == @users
      response.should render_template("layouts/application", "directory/index")
    end
  end

  describe "GET directory_search" do
    it "assigns all index as @directory_search" do
      get :directory_search
      response.header['Content-Type'].should include 'text/html'
    end
  end


end

