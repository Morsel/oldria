require_relative '../../spec_helper'

describe Admin::MediaRequestsController do
  integrate_views

  before(:each) do
    @sender = FactoryGirl.create(:media_user)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @media_request = FactoryGirl.create(:media_request, :id => 29, :sender => @sender)
  end

  describe "GET index" do
    it "should render index template" do
      MediaRequest.expects(:find).returns([])
      get :index
      response.should render_template(:index)
    end

    it "should assign @media_requests" do
      sender = FactoryGirl.create(:media_user, :id => 49)
      media_requests = [@media_request]
      MediaRequest.expects(:find).returns(media_requests)
      get :index
      assigns[:media_requests].should == media_requests
    end
  end

  describe "GET show" do
    before(:each) do
      MediaRequest.stubs(:find).returns(@media_request)
      get :show, :id => '29'
    end

    it "should render show template" do
      response.should render_template(:show)
    end

    it "should assign @media_request" do
      assigns[:media_request].should == @media_request
    end
  end

  describe "GET edit" do
    before(:each) do
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

  end

  describe "PUT update" do
    before(:each) do
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
      MediaRequest.stubs(:find).returns(@media_request)
      @media_request.stubs(:approve!)
      @media_request.stubs(:valid?).returns(true)
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
