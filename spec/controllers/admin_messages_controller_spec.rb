require_relative '../spec_helper'
 
describe AdminMessagesController do
  integrate_views
  before(:each) do
    fake_admin_user
    @admin_message = FactoryGirl.create(:admin_message)
  end

  it "show action should render show template" do
    get :show, :id => Admin::Message.first
    response.should be_success
  end

  it "show action should render show template" do
    get :read, :id => Admin::Message.first
    response.should be_success
  end

end   
