require 'spec/spec_helper'

describe MediaRequestConversationsController do
  integrate_views

  before(:each) do
    @employee = Factory(:user)
    @recipient = Factory(:employment, :employee => @employee)
    @mrc = Factory(:media_request_conversation, :recipient => @recipient)
    MediaRequestConversation.stubs(:find).returns(@mrc)
    controller.stubs(:current_user).returns(@employee)
  end

  describe "GET show" do
    it "should be successful" do
      get :show, :id => 98
      response.should be_success
    end

    it "should redirect if the user isn't a part of this conversation" do
      controller.stubs(:current_user).returns(Factory(:user))
      get :show, :id => @mrc.id
      response.should redirect_to(root_url)
    end

    it "should assign @media_request_conversation" do
      get :show, :id => @mrc.id
      assigns[:media_request_conversation].should == @mrc
    end
  end
end
