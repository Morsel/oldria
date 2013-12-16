require_relative '../../spec_helper'

describe Soapbox::PromotionsController do

  #Delete these examples and add some real ones
  it "should use Soapbox::PromotionsController" do
    controller.should be_an_instance_of(Soapbox::PromotionsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
