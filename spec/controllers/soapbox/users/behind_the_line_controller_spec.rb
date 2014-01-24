require_relative '../../../spec_helper'

describe Soapbox::Users::BehindTheLineController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET topic" do
    it "Get topic" do
    	@topic = FactoryGirl.create(:topic)
      get :topic,:user_id=>@user.id
    end
  end


end
