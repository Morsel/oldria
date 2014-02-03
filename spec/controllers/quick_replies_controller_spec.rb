require_relative '../spec_helper'
 
describe QuickRepliesController do
  integrate_views

  before(:each) do
    @quick_reply = FactoryGirl.create(:quick_reply)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

end
