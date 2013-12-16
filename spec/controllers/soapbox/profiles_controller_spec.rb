require_relative '../../spec_helper'

describe Soapbox::ProfilesController do

  describe "GET 'show'" do
    it "should be successful" do
      user = FactoryGirl.create(:user, :subscription => FactoryGirl.create(:subscription))
      user.publish_profile = true
      User.expects(:find).returns(user)
      get 'show', :id => user.username
      response.should be_success
    end
  end
end
