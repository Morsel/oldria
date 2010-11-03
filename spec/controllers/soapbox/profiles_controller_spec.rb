require 'spec_helper'

describe Soapbox::ProfilesController do

  describe "GET 'show'" do
    it "should be successful" do
      user = Factory(:user, :subscription => Factory(:subscription))
      user = Factory(:user, :premium_account => true)
      user.prefers_publish_profile = true
      User.expects(:find).returns(user)
      get 'show', :id => user.username
      response.should be_success
    end
  end
end
