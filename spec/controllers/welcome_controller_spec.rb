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
        @user = Factory.stub(:user)
        @user.stubs(:update).returns(true)
        controller.stubs(:current_user).returns(@user)
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
        assigns[:has_see_more].should == true
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