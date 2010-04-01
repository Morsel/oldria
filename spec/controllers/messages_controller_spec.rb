require 'spec/spec_helper'

describe MessagesController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET archive" do
    it "should be successful" do
      get :archive
      response.should be_success
    end
  end
end
