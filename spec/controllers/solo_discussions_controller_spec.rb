require_relative '../spec_helper'

describe SoloDiscussionsController do
  
  before(:each) do
    fake_normal_user
  end

  describe "GET 'show'" do
    it "should be successful" do
      discussion = Factory(:solo_discussion)
      get 'show', :id => discussion.id
      response.should be_success
    end
  end
end
