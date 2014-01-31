require_relative '../spec_helper'
 
describe HolidayConversationsController do
  integrate_views

  before(:each) do
  	@holiday_conversation = FactoryGirl.create(:holiday_conversation)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "show action should render show template" do
    get :show, :id => HolidayConversation.first
    response.should render_template(:show)
  end
 
  it "update action should render edit template when model is valid" do
    HolidayConversation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => HolidayConversation.first
    response.should redirect_to admin_holiday_path(@holiday_conversation.holiday)
  end


end
