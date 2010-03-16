require 'spec/spec_helper'
 
describe HolidayConversationsController do
  integrate_views
  before(:each) do
    Factory(:holiday_conversation)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => HolidayConversation.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    HolidayConversation.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    HolidayConversation.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(holiday_conversation_url(assigns[:holiday_conversation]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => HolidayConversation.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    HolidayConversation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => HolidayConversation.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    HolidayConversation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => HolidayConversation.first
    response.should redirect_to(holiday_conversation_url(assigns[:holiday_conversation]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    holiday_conversation = HolidayConversation.first
    delete :destroy, :id => holiday_conversation
    response.should redirect_to(holiday_conversations_url)
    HolidayConversation.exists?(holiday_conversation.id).should be_false
  end
end
