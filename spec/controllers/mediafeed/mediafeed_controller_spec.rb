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

  describe "GET request_information" do
    it "assigns all index as @request_information for menu item" do
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
    @promotion = FactoryGirl.create(:promotion)
      get :request_information,:user_id=>@user.id,:menu_item_id=>@menu_item.id,:promotion_id=>@promotion.id 
      expect { get :request_information }.to_not render_template(layout: "application") if request.xhr?
    end

    it "assigns all index as @request_information for promotion" do
      @promotion = FactoryGirl.create(:promotion)
        get :request_information,:user_id=>@user.id,:promotion_id=>@promotion.id 
        expect { get :request_information }.to_not render_template(layout: "application") if request.xhr?
    end
  end   

  describe "GET media_subscription" do
    it "get media_subscription" do
      @subscriptions = @user.media_newsletter_subscriptions.map{|e| e unless e.restaurant.blank?}.compact.paginate({:page => 5, :per_page => @per_page})
      @digest_subsriptions = @user.get_digest_subscription.paginate({:page => 5, :per_page => @per_page})
      @user.media_newsletter_setting || @user.build_media_newsletter_setting.save  
      get :media_subscription,:user_id=>@user.id
      assigns[:user].should == @user
      response.should render_template("layouts/application", "media_subscription")
    end
  end

  describe "GET media_all_unsubscribe" do
    it "get media_all_unsubscribe" do
      @user = FactoryGirl.create(:user,:role=>"media")
      get :media_all_unsubscribe,:user_id=>@user.id
      response.should redirect_to :action => :media_subscription
    end
  end

  describe "GET media_opt_update" do
    it "get media_opt_update" do
      get :media_opt_update,:user_id=>@user.id
      response.should redirect_to :action => :media_subscription
      response.should redirect_to(mediafeed_media_subscription_path)
    end
  end

end

