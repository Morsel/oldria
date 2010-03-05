require 'spec_helper'

describe InboxesController do

  #Delete these examples and add some real ones
  it "should use InboxesController" do
    controller.should be_an_instance_of(InboxesController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
