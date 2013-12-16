require_relative '../spec_helper'

# This controller is mapped as resource, not resources
# Thus, no id is needed in paths
describe FeedsController do
  integrate_views

  before do
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET show" do
    it "should be successful" do
      get :show
      response.should be_success
    end
  end

  describe "GET edit" do
    it "should be successful" do
      get :edit
      response.should be_success
    end
  end

  describe "PUT update" do
    before do

    end

    it "should update the current user's feed subscriptions" do
      feed_ids = ['1','3']
      @user.expects(:feed_ids=).with(feed_ids)
      put :update, :feed_ids => feed_ids
    end

    it "should redirect to the main feeds page" do
      put :update
      response.should redirect_to(feeds_path)
    end
  end
end
