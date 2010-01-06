require 'spec/spec_helper'

describe MediaRequestsController do
  integrate_views

  before(:each) do
    @user = Factory(:user, :publication => 'New York Times')
    @user.has_role! :media
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET new" do
    context "with no extra params" do
      before do
        get :new
      end

      it "should render new template" do
        response.should render_template(:new)
      end

      it "should set the current_user as @sender" do
        assigns[:sender].should == @user
      end

      it "should include a search form" do
        response.should have_selector(:form, :action => new_media_request_path)
      end
    end

    context "with search params" do
      before do
        @restaurant = Factory(:restaurant, :name => "Long John Silver's", :id => 3)
        user = Factory(:user, :name => "John Smith")
        @employment = Factory(:employment, :restaurant => @restaurant, :employee => user)
        get :new, :search => { :restaurant_name_like => "Long" }
      end

      it { response.should be_success }

      it "should assign @employments" do
        assigns[:employments].should == [@employment]
      end

      it "should set the default publication as the sender's publication" do
        assigns[:media_request].should_not be_nil
        assigns[:media_request].publication.should == @user.publication
      end
    end
  end

  describe "POST create" do
    context "with valid media request" do
      before(:each) do
        @media_request = Factory.build(:media_request, :sender_id => @user.id)
        @user.media_requests.expects(:build).returns(@media_request)
        post :create
      end

      it { response.should redirect_to(edit_media_request_path(@media_request))}
    end

    context "with invalid media request" do
      before(:each) do
        @media_request = Factory.build(:media_request, :sender_id => @user.id, :recipients => [])
        @user.media_requests.expects(:build).returns(@media_request)
        post :create
      end

      it { response.should render_template(:new) }
      it { response.flash[:error].should_not be_nil }
    end
  end

  describe "GET edit" do
    before do
      @media_request = Factory(:media_request, :status => 'draft', :sender => @user)
    end

    it "should render new template" do
      get :edit, :id => @media_request.id
      response.should render_template(:edit)
    end

    it "should set the default publication as the sender's publication" do
      get :edit, :id => @media_request.id
      assigns[:media_request].publication.should == @user.publication
    end
  end
end
