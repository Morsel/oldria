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
  
  describe "GET edit" do
    before(:each) do
      @media_request = Factory.stub(:media_request, :id => 29)
      MediaRequest.stubs(:find).returns(@media_request)
    end

    it "should render the edit template" do
      get :edit, :id => 29
      response.should render_template(:edit)
    end
    
    it "should assign @media_request" do
      get :edit, :id => 29
      assigns[:media_request].should == @media_request
    end

    it "should list the recipients" do
      @media_request.stubs(:recipients).returns([Factory.stub(:user, :name => "Jimmy")])
      get :edit, :id => 29
      response.should have_selector("form") do |form|
        form.should contain("Jimmy")
      end
    end
  end
end
