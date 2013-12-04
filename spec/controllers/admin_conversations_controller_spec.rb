require_relative '../spec_helper'

describe AdminConversationsController do
  integrate_views
  before(:each) do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
    Factory(:employment, :employee => @user)
    message = Factory(:admin_message, :type => 'Admin::Qotd')
    Factory(:admin_conversation, :admin_message => message, :recipient => @user)
  end

  it "show action should render show template" do
    get :show, :id => Admin::Conversation.first
    response.should render_template(:show)
  end
end
