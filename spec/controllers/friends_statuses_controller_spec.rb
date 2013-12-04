require_relative '../spec_helper'

describe FriendsStatusesController do
  integrate_views

  before do
    @current_user = Factory.stub(:user)
    @current_user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@current_user)
  end

  describe "GET show" do
    it "should be successful" do
      get :show
      response.should be_success
    end

    it "should assign statuses" do
      statuses = [Factory.stub(:status)]
      statuses.stubs(:all => statuses, :paginate => statuses)
      Status.expects(:friends_of_user).returns(statuses)
      get :show
      assigns[:statuses].should_not be_nil
    end
  end
end
