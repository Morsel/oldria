require 'spec/spec_helper'

describe InboxesController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET show" do
    it "should be successful" do
      get :show
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
