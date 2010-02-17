require 'spec/spec_helper'

def fake_normal_user
  @user = Factory.stub(:user)
  @user.stubs(:update).returns(true)
  controller.stubs(:current_user).returns(@user)
  controller.stubs(:require_admin).returns(false)
end

describe AdminConversationsController do
  integrate_views
  before(:each) do
    fake_normal_user
    message = Factory(:admin_message, :type => 'Admin::Qotd')
    Factory(:admin_conversation, :admin_message => message)
  end

  it "show action should render show template" do
    get :show, :id => Admin::Conversation.first
    response.should render_template(:show)
  end
end
