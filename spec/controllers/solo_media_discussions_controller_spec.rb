require_relative '../spec_helper'

describe SoloMediaDiscussionsController do
  
  before(:each) do
    fake_normal_user
    User.stubs(:find).returns(@user)
  end

  describe "GET 'show'" do
    it "should be successful" do
      discussion = FactoryGirl.create(:solo_media_discussion)
      discussion.stubs(:employee).returns(@user)
      get 'show', :id => discussion.id
      response.should be_redirect
    end
  end
end
