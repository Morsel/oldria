require 'spec/spec_helper'

describe CompleteRegistrationsController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET show" do
    it "should be successful" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "GET update" do
    it "should re-render the form when data is not valid" do
      User.any_instance.stubs(:valid?).returns(false)
      put :update
      response.should render_template(:show)
    end

    it "should redirect to the dashboard when data is valid" do
      User.any_instance.stubs(:valid?).returns(true)
      put :update
      response.should redirect_to(root_path)
    end
  end
end
