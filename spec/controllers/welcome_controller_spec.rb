require_relative '../spec_helper'

describe WelcomeController do

  before(:all) do
    ActionController::Base.perform_caching = true
  end

  after(:all) do
    Rails.cache.clear
    ActionController::Base.perform_caching = false
  end

  describe "GET index" do

    context "for anonymous users" do
      it "should render the index.html template" do
        get :index
        response.should render_template(:index)
      end
    end

    context "for logged in spoonfeed users" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.stubs(:update).returns(true)
        controller.stubs(:current_user).returns(@user)

        Rails.cache.clear
        @key = controller.action_cache_key(controller.dashboard_cache_key)
      end
 
      it "should render the dashboard template" do
        get :index
        response.should render_template(:dashboard)
      end
      
      it "should see link see more" do
        11.times do |i|
          FactoryGirl.create(:profile_answer)
        end
        get :index
        assigns[:has_more].should == true
      end

      pending "fixing dashboard caching" do
        it "should cache action if no unread announcement exists" do
          @user.stubs(:unread_announcements).returns([])
          get :index
          response.should render_template(:dashboard)
          Rails.cache.exist?(@key).should be_true
        end
      end

      it "should not cache action if unread announcement exists" do
        @user.stubs(:unread_announcements).returns([FactoryGirl.create(:announcement)])
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
        @user = FactoryGirl.create(:media_user)
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
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.stubs(:update).returns(true)
        controller.stubs(:current_user).returns(@user)

        Rails.cache.clear
        @key = controller.action_cache_key(controller.dashboard_cache_key)
      end

      pending "fixing dashboard caching" do
        it "should clear action cache for dashboard" do
          get :index
          Rails.cache.exist?(@key).should be_true

          get :refresh
          Rails.cache.exist?(@key).should be_false
        end
      end

      it "should create fresh cache for recent comments" do
        Rails.cache.exist?("load_recent_comments").should be_false
        get :refresh
        Rails.cache.exist?("load_recent_comments").should be_true
      end
    end

  end

end
