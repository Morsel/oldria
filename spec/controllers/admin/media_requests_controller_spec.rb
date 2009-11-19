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
      user = Factory.stub(:user, :name => "Jimmy Nono")
      @media_request.stubs(:recipients).returns([Factory.stub(:employment, :employee => user)])
      get :edit, :id => 29
      response.should have_selector("form") do |form|
        form.should contain("Jimmy")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @media_request = Factory.stub(:media_request, :id => 29)
      MediaRequest.stubs(:find).returns(@media_request)
      @params = {'these' => 'params'}
    end

    it "should assign @media_request" do
      @media_request.stubs(:update_attributes)
      put :update, :id => 29, :media_request => @params
      assigns[:media_request].should == @media_request
    end

    it "should redirect when update is successful and flash success message" do
      @media_request.expects(:update_attributes).with(@params).returns(true)
      put :update, :id => 29, :media_request => @params
      response.should redirect_to(admin_media_requests_path)
      flash[:success].should_not be_nil
    end

    it "should render the edit page when update is unsuccessful" do
      @media_request.expects(:update_attributes).with(@params).returns(false)
      put :update, :id => 29, :media_request => @params
      response.should render_template(:edit)
    end
  end

  describe "PUT approve" do
    before(:each) do
      @media_request = Factory.stub(:media_request, :id => 45)
      MediaRequest.stubs(:find).returns(@media_request)
      @media_request.stubs(:approve!)
    end

    it "should assign @media_request" do
      put :approve, :id => 45
      assigns[:media_request].should == @media_request
    end

    it "should approve the media request" do
      @media_request.expects(:approve!).returns(true)
      put :approve, :id => 45
    end

    context "responding to html" do
      it "should redirect to the index" do
        put :approve, :id => 45
        response.should redirect_to(admin_media_requests_path)
      end

      it "should flash a success when successful" do
        @media_request.stubs(:approve!).returns(true)
        put :approve, :id => 45
        flash[:success].should contain("Successfully approved")
      end

      it "should flash a error when unsuccessful" do
        @media_request.stubs(:approve!).returns(false)
        put :approve, :id => 45
        flash[:error].should contain("unable to approve")
      end
    end
  end
end
