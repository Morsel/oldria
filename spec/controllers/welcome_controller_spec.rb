require 'spec/spec_helper'

describe WelcomeController do
  integrate_views
  enable_memcache_stub

  describe "GET index" do
    context "for anonymous users" do
      it "should render the index.html template" do
        get :index
        response.should render_template(:index)
      end
    end

    context "for logged in spoonfeed users" do
      before do
        @user = Factory.stub(:user)
        @user.stubs(:update).returns(true)
        Rails.cache.clear
        controller.stubs(:current_user).returns(@user)
        @key = controller.action_cache_key(controller.dashboard_cache_key)
      end
 
      it "should render the dashboard template" do
        get :index
        response.should render_template(:dashboard)
      end
      
      it "should see link see more" do
        11.times do |i|
          Factory(:profile_answer)
        end
        get :index
        assigns[:has_more].should == true
      end

      it "should cache action if no unread announcement exists" do
        @user.stubs(:unread_announcements).returns([])
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?(@key).should be_true
      end

      it "should not cache action if unread announcement exists" do
        @user.stubs(:unread_announcements).returns([Factory(:announcement)])
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?(@key).should be_false
      end

      it "should cache recent_comments" do
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?("load_recent_comments").should be_true
      end
    end

    context "for logged in media users" do
      before do
        @user = Factory(:media_user)
        @user.stubs(:update).returns(true)
        controller.stubs(:current_user).returns(@user)
      end

      it "should render the dashboard" do
        get :index
        response.should render_template(:dashboard)
      end
    end
  end

  describe "GET refresh" do
    context "for logged in spoonfeed users" do
      before do
        @user = Factory.stub(:user)
        @user.stubs(:update).returns(true)
        Rails.cache.clear
        controller.stubs(:current_user).returns(@user)
        @key = controller.action_cache_key(controller.dashboard_cache_key)
      end

      it "should clear action cache for dashboard" do
        get :index
        Rails.cache.exist?(@key).should be_true

        get :refresh
        Rails.cache.exist?(@key).should be_false
      end

      it "should create fresh cache for recent comments" do
        Rails.cache.exist?("load_recent_comments").should be_false
        get :refresh
        Rails.cache.exist?("load_recent_comments").should be_true
      end
    end
  end
end
