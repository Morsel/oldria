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
      get :qotd
      assigns[:questions].should == [entry]
      response.should render_template(:all)
    end

    it "should show trend questions" do
      entry = Factory(:soapbox_entry, :featured_item => Factory(:trend_question))
      get :trend
      assigns[:questions].should == [entry]
      response.should render_template(:all)
    end
  end

  describe "search for questions and comments" do
    it "should find trend question" do
      entry = Factory(:soapbox_entry, :featured_item => Factory(:trend_question))
      get :search, :query => entry.featured_item.subject
      assigns[:trend_questions_found].should == [entry.featured_item]
    end

    it "should find question of the day" do
      pending "should have Admin::Qotd in featured_item_type" do
        entry = Factory(:soapbox_entry)
        get :search, :query => "question"
        assigns[:qotds_found].should == [entry.featured_item]
      end
    end
  end

end
