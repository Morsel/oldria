require 'spec_helper'

describe Soapbox::ProfilesController do

  #Delete these examples and add some real ones
  it "should use Soapbox::ProfilesController" do
    controller.should be_an_instance_of(Soapbox::ProfilesController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
