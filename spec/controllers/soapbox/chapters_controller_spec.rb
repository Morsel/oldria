require 'spec_helper'

describe Soapbox::ChaptersController do

  describe "GET 'show'" do
    it "should be successful" do
      Chapter.stubs(:find).returns(Factory(:chapter))
      get 'show', :id => 1
      response.should be_success
    end
  end
end
