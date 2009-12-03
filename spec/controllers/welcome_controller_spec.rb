require 'spec/spec_helper'

describe WelcomeController do
  integrate_views

  describe "GET index" do
    context "for anonymous users" do
      it "should render the index.html template" do
        get :index
        response.should render_template(:index)
      end
    end

    context "for logged in spoonfeed users" do
      before do
        @user = Factory(:user)
        controller.stubs(:current_user).returns(@user)
      end

      it "should render the dashboard template" do
        get :index
        response.should render_template(:dashboard)
      end
    end

    context "for logged in media users" do
      before do
        @user = Factory(:media_user)
        controller.stubs(:current_user).returns(@user)
      end

      it "should render the mediahome template" do
        get :index
        response.should render_template(:mediahome)
      end
    end
  end
end