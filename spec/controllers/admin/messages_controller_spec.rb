require 'spec/spec_helper'

describe Admin::MessagesController do
  integrate_views

  before(:each) do
    fake_admin_user
    @message = Factory.stub(:admin_message)
  end

  describe "GET index" do
    it "assigns all admin_messages as @admin_messages" do
      get :index
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message" do
      @message.stubs(:id).returns(37)
      Admin::Message.stubs(:find).with("37").returns(@message)
      get :show, :id => "37"
      response.should be_success
    end
  end

  describe "DELETE destroy" do
    it "assigns the requested message as @message" do
      @message.stubs(:id).returns(37)
      Admin::Message.stubs(:find).with("37").returns(@message)
      @message.expects(:destroy)
      delete :destroy, :id => "37"
    end
  end
end
