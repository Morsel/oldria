require 'spec_helper'
require 'ruby-debug'

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
      entry = Factory(:soapbox_entry)
      get :show, :id => entry.id
      assigns[:feature].should_not be_nil
    end
  end

  describe "showing all questions" do
    it "should show questions of the day" do
      entry = Factory(:soapbox_entry)
      entry.reload
      entry.update_attributes("featured_item_type" => "Admin::Qotd")
      get :qotd
      assigns[:questions].should == [entry]
    end

    it "should show trend questions" do
      entry = Factory(:soapbox_entry, :featured_item => Factory(:trend_question))
      get :trend
      assigns[:questions].should == [entry]
    end
  end

end
