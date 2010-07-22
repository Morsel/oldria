require 'spec_helper'

describe SoapboxController do

  describe "GET index" do
    it "should be successful" do
      get :index
      SoapboxEntry.expects(:all).returns([])
      response.should be_success
    end
  end
end
