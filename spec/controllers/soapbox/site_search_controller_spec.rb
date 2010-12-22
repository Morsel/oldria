require 'spec_helper'

describe Soapbox::SiteSearchController do

  #Delete these examples and add some real ones
  it "should use SiteSearchController" do
    controller.should be_an_instance_of(Soapbox::SiteSearchController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
