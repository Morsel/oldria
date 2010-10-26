require 'spec_helper'

describe Soapbox::ProfilesController do

  describe "GET 'show'" do
    it "should be successful" do
      user = Factory(:user, :subscription => Factory(:subscription))
      User.expects(:find).returns(user)
      get 'show', :id => user.username
      response.should be_success
    end
  end
end
