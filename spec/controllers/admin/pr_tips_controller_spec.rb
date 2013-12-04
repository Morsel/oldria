require_relative '../spec_helper'

describe Admin::PrTipsController do
  integrate_views
  before(:each) do
    fake_admin_user
    Factory(:admin_message, :type => 'Admin::PrTip')
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Admin::PrTip.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Admin::PrTip.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(admin_messages_path)
  end

  it "edit action should render edit template" do
    get :edit, :id => Admin::PrTip.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Admin::PrTip.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Admin::PrTip.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Admin::PrTip.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Admin::PrTip.first
    response.should redirect_to(admin_messages_path)
  end
end
