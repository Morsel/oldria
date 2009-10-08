require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MediaRequestConversationsController do
  integrate_views

  before(:each) do
    @mrc = Factory(:media_request_conversation, :id => 98)
    MediaRequestConversation.stubs(:find).returns(@mrc)
    controller.stubs(:current_user).returns(Factory(:user))
  end
  
  describe "GET show" do
    it "should be successful" do
      get :show, :id => 98
      response.should be_success
    end
    it "should assign @media_request_conversation" do
      get :show, :id => 98
      assigns[:media_request_conversation].should == @mrc
    end
  end
end
