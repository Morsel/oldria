require 'spec/spec_helper'

describe Admin::ContentRequestsController do
  integrate_views

  before(:each) do
    fake_admin_user
    Factory(:admin_message, :type => "Admin::ContentRequest")
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "GET 'create'" do
    it "should redirect on success" do
      Admin::ContentRequest.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(admin_messages_path)
    end

    it "should re-render of error" do
      Admin::ContentRequest.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => Admin::ContentRequest.first
      response.should render_template(:edit)
    end
  end

  describe "GET 'update'" do
    it "should redirect on success" do
      Admin::ContentRequest.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Admin::ContentRequest.first
      response.should redirect_to(admin_messages_path)
    end

    it "should re-render on error" do
      Admin::ContentRequest.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Admin::ContentRequest.first
      response.should render_template(:edit)
    end
  end
end
