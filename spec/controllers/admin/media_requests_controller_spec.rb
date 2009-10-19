require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::MediaRequestsController do
  integrate_views

  before(:each) do
    @sender = Factory(:user)
    @sender.has_role! :media
    controller.stubs(:current_user).returns(Factory(:admin))
  end

  describe "GET index" do
    it "should render new template" do
      get :index
      response.should render_template(:index)
    end

    it "should assign @media_requests" do
      media_requests = [Factory.stub(:media_request)]
      MediaRequest.expects(:find).returns(media_requests)
      get :index
      assigns[:media_requests].should == media_requests
    end
  end

end
