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
      end

      it "should render the dashboard template" do
        get :index
        response.should render_template(:dashboard)
      end

      it "should cache action if no unread announcement exists" do
        @user.stubs(:unread_announcements).returns([])
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?("views/" + controller.cache_key).should be_true
      end

      it "should not cache action if unread announcement exists" do
        @user.stubs(:unread_announcements).returns([Factory(:announcement)])
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?("views/" + controller.cache_key).should be_false
      end

      it "should cache recent_comments" do
        get :index
        response.should render_template(:dashboard)
        Rails.cache.exist?(controller.comments_cache_key).should be_true
      end
    end

    context "for logged in media users" do
      before do
        @user = Factory(:media_user)
        @user.stubs(:update).returns(true)
        controller.stubs(:current_user).returns(@user)
      end

      it "should render the mediahome template" do
        pending "mediafeed" do
          get :index
          response.should render_template(:mediahome)
        end
      end
    end
  end
end
