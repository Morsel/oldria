require 'spec/spec_helper'
 
describe QuickRepliesController do
  before do
    fake_normal_user
  end
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    QuickReply.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    QuickReply.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(ria_messages_path)
  end
end
