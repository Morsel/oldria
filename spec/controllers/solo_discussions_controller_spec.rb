require_relative '../spec_helper'

describe SoloDiscussionsController do
  
  before(:each) do
    fake_normal_user
  end

  describe "GET 'show'" do
    it "should be successful" do
      discussion = FactoryGirl.create(:solo_discussion)
      get 'show', :id => discussion.id
      response.should be_success
    end
  end

  describe "GET 'read'" do
    it "should be successful" do
      discussion = FactoryGirl.create(:solo_discussion)
      get 'read', :id => discussion.id
      response.should be_success
    end
  end
  
end
