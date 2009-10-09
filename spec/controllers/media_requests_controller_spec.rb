require File.dirname(__FILE__) + '/../spec_helper'
 
describe MediaRequestsController do
  integrate_views

  before(:each) do
    @user = Factory(:user)
    @user.has_role! :media
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "should set the current_user as @sender" do
      get :new
      assigns[:sender].should == @user
    end
    
    it "should collect the recipients into @recipient_ids" do
      User.stubs(:find).returns([@user])
      get :new, :recipient_ids => ['12', '34']
      assigns[:recipient_ids].should == ['12','34']
    end

    it "should create a hidden field for each recipient" do
      User.stubs(:find).returns([@user])
      id_array = ['12', '34']
      get :new, :recipient_ids => id_array
      id_array.each do |idstring|
        response.should have_selector(:form) do |form|
          form.should have_selector(:input, :type => 'hidden', :value => idstring)
        end
      end
    end
  end
  
  describe "POST create" do
    before(:each) do
      @media_request = MediaRequest.new(:sender_id => @user.id)
    end

    it "should build a new media request for the current user" do
      @user.media_requests.expects(:build).returns(@media_request)
      post :create
    end

    it "should build a new media request conversation for each recipient" do
      @user.media_requests.stubs(:build).returns(@media_request)
      @receiver1 = Factory(:user, :id => 49)
      @receiver2 = Factory(:user, :id => 54)
      post :create, :recipient_ids => ["54","49"]
      @receiver1.media_request_conversations.count.should == 1
    end
  end
end
