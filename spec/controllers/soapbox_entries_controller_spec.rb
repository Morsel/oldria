require_relative '../spec_helper'
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
      entry = Factory(:soapbox_entry, :featured_item => question = Factory(:qotd))
      get :qotd, :view_all => true
      assigns[:featured_items].should == [entry.featured_item]
    end

    it "should show trend questions" do
      entry = Factory(:soapbox_entry, :featured_item => Factory(:trend_question))
      get :trend
      assigns[:featured_items].should == [entry.featured_item]
    end
  end

end
