require_relative '../spec_helper'

describe Admin::SiteActivitiesController do

  before(:each) do
    @user = Factory.stub(:admin)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
