require_relative '../../spec_helper'

describe Admin::BrainTreeWebhookController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET varify" do
    it "varify" do
      get :varify
      expect(response).to render_template(:text => '') 
    end
  end

end   