require_relative '../../spec_helper'

describe Mediafeed::MediaRequestsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:user, :publication => 'New York Times')
    @user.has_role! :media
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET new" do
    before do
      get :new
    end

    it "should render new template" do
      response.should render_template(:new)
    end

    it "should include a search form" do
      response.should have_selector(:form)
    end
  end

  describe "POST create" do
    before do
      @media_request = FactoryGirl.build(:media_request, :sender_id => @user.id)
      @user.media_requests.expects(:build).returns(@media_request)
    end

    context "with valid media request" do
      before(:each) do
        @media_request.stubs(:valid?).returns(true)
        post :create, :search => { :subject_matters_id_equals_any => ["1"] }, :media_request => {}
      end

      it { response.should redirect_to(mediafeed_media_request_path(@media_request))}
    end

    context "with invalid media request" do
      before(:each) do
        @media_request.stubs(:valid?).returns(false)
        post :create
      end

      it { response.should render_template(:new) }
      it { request.flash[:error].should_not be_nil }
    end
    
    it "should require the user to submit a search with subject matter" do
      post :create, :search => { :subject_matters_id_equals_any => [] }, :media_request => {}
      response.should render_template(:new)
      request.flash[:error].should_not be_nil
    end

  end

  describe "GET edit" do
    before do
      @media_request = FactoryGirl.create(:media_request, :sender => @user)
      MediaRequest.stubs(:find).returns(@media_request)
    end

    it "should render edit template" do
      get :edit, :id => @media_request.id
      response.should render_template(:edit)
    end

    it "should set the default publication as the sender's publication" do
      get :edit, :id => @media_request.id
      assigns[:media_request].publication.should == @user.publication
    end
  end

  describe "GET index" do
    it "assigns all media_request as @media_request" do
    @media_request = FactoryGirl.create(:media_request, :sender => @user)
      MediaRequest.stubs(:find).returns([@media_request])
      get :index
      assigns[:media_requests].should == [@media_request]
    end
  end

  describe "GET show" do
    it "Render the show template" do
    @media_request = FactoryGirl.create(:media_request, :sender => @user)
      MediaRequest.stubs(:find).returns([@media_request])
      get :show
      response.should render_template("layouts/application", "show")
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested media_request" do
      @media_request = FactoryGirl.create(:media_request, :sender => @user)
      MediaRequest.expects(:find).with("37").returns(@media_request)
      @media_request.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(media_requests_url) 
    end
  end

  describe "GET discussion" do
    it "Render the discussion template" do
    @media_request = FactoryGirl.create(:media_request, :sender => @user)
      MediaRequest.stubs(:find).returns([@media_request])
      get :discussion,:discussion_type => "test"
      response.should render_template("layouts/application", "discussion")
    end
  end


end
