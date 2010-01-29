require 'spec/spec_helper'

describe FeedsController do
  integrate_views

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end
end
