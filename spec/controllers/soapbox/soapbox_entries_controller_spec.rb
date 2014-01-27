require_relative '../../spec_helper'

describe Soapbox::SoapboxEntriesController do
  integrate_views

  describe "GET index" do
    it "GET index" do
      get :index
      response.should render_template("layouts/soapbox", "index")
    end
  end

  describe "GET trend" do
    it "GET trend if view_all in params" do
      @soapbox_entry = FactoryGirl.create(:soapbox_entry)
      get :trend,:view_all=>"view_all"
      response.should render_template("layouts/soapbox", "trend")
    end
    it "Work for else condition" do
      @soapbox_entry = FactoryGirl.create(:soapbox_entry)
      get :trend
      response.should render_template("layouts/soapbox", "trend")
    end
  end

  describe "GET qotd" do
    it "GET qotd if view_all in params" do
      @admin_message = FactoryGirl.create(:admin_message)
      get :qotd,:view_all=>"view_all"
      response.should render_template("layouts/soapbox", "qotd")
    end
    it "Work for else condition" do
      @admin_message = FactoryGirl.create(:admin_message)
      get :qotd
      response.should render_template("layouts/soapbox", "qotd")
    end
  end

  describe "frontburner" do
    it "should render the template dashboard" do
      @admin_message = FactoryGirl.create(:admin_message)
      get :qotd,:view_all=>"view_all"
      response.should render_template("layouts/soapbox", "dashboard")
    end
  end  

end
