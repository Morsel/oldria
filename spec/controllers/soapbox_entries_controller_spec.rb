require 'spec_helper'

describe Soapbox::SoapboxEntriesController do
  before do
    controller.stubs(:require_http_authenticated).returns(true)
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "showing a single soapbox entry" do

    it "should find the entry" do
      Factory(:soapbox_entry)
      get :show, :id => 1
      assigns[:feature].should_not be_nil
    end
  end

end
