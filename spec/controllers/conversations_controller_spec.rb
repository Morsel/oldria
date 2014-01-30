require_relative '../spec_helper'

describe ConversationsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "should render the new template" do
      get :new
      response.should render_template(:new)
    end
  end



end
