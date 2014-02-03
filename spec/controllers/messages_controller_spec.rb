require_relative '../spec_helper'

describe MessagesController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET ria" do
    it "should be successful" do
      get :ria
      response.should be_success
    end
  end

  describe "GET archive" do
    it "should be successful" do
      get :archive
      response.should be_success
    end
  end
  
  describe "GET private" do
    it "should be successful" do
      get :private
      response.should be_success
    end
  end
  
  describe "GET media_requests" do
    it "should be successful" do
      get :media_requests
      response.should be_success
    end
  end
  
  describe "GET staff_discussions" do
    it "should be successful" do
      get :staff_discussions
      response.should be_success
    end
  end

  describe "GET restaurant_requests" do
    it "should be successful" do
      get :restaurant_requests
      response.should be_success
    end
  end

end
