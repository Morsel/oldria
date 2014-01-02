 require_relative '../../spec_helper'

describe Admin::FeaturedProfilesController do
  integrate_views


  before(:each) do
    @featured_profile = FactoryGirl.create(:featured_profile)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
    FeaturedProfile.stubs(:find).returns(@featured_profile)
  end

  describe "GET index" do
    it "assigns all featured_profiles as @featured_profiles" do
      FeaturedProfile.stubs(:find).returns([@featured_profile])
      get :index
      assigns[:featured_profiles].should == [@featured_profile]
    end
  end  

  describe "GET new for user " do
    it "assigns a new featured_profile as @featured_profile" do
      FeaturedProfile.stubs(:new).returns(@featured_profile)
      get :new,:type => "User"
      assigns[:feature].should equal(@featured_profile)
    end
  end

  describe "GET new for restaurant " do
    it "assigns a new featured_profile as @featured_profile" do
      FeaturedProfile.stubs(:new).returns(@featured_profile)
      get :new,:type => "Restaurant"
      assigns[:feature].should equal(@featured_profile)
    end
  end

  describe "GET edit for user" do
    it "assigns the requested featured_profile as @featured_profile" do
      FeaturedProfile.stubs(:find).returns(@featured_profile)
      get :edit, :id => "37",:type => "User"
      assigns[:feature].should equal(@featured_profile)
    end
  end

  describe "GET edit for restaurant" do
    it "assigns the requested featured_profile as @featured_profile" do
      FeaturedProfile.stubs(:find).returns(@featured_profile)
      get :edit, :id => "37",:type => "Restaurant"
      assigns[:feature].should equal(@featured_profile)
    end
  end

  describe "POST create for user and restaurant" do

    describe "with valid params for user" do
      before(:each) do
        FeaturedProfile.stubs(:new).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created featured_profile as @featured_profile" do
        post :create, :featured_profile => {},:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "redirects to the created featured_profile" do
        post :create, :featured_profile => {},:type => "User"
        response.should redirect_to(admin_featured_profiles_url)
      end
    end
    describe "with valid params for restaurant" do
      before(:each) do
        FeaturedProfile.stubs(:new).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created featured_profile as @featured_profile" do
        post :create, :featured_profile => {},:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "redirects to the created featured_profile" do
        post :create, :featured_profile => {},:type => "Restaurant"
        response.should redirect_to(admin_featured_profiles_url)
      end
    end

    describe "with invalid params for user" do
      before(:each) do
        FeaturedProfile.any_instance.stubs(:save).returns(false)
        FeaturedProfile.stubs(:new).returns(@featured_profile)
      end

      it "assigns a newly created but unsaved featured_profile as @featured_profile" do
        post :create, :featured_profile => {:these => 'params'},:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "re-renders the 'new' template" do
        post :create, :featured_profile => {},:type => "User"
        response.should render_template('new')
      end
    end

    describe "with invalid params for restaurant" do
      before(:each) do
        FeaturedProfile.any_instance.stubs(:save).returns(false)
        FeaturedProfile.stubs(:new).returns(@featured_profile)
      end

      it "assigns a newly created but unsaved featured_profile as @featured_profile" do
        post :create, :featured_profile => {:these => 'params'},:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "re-renders the 'new' template" do
        post :create, :featured_profile => {},:type => "Restaurant"
        response.should render_template('new')
      end
    end
  end   

  describe "PUT update" do

    describe "with valid params for user " do
      before(:each) do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested featured_profile" do
        FeaturedProfile.expects(:find).with("37").returns(@featured_profile)
        put :update, :id => "37", :featured_profile => {:these => 'params'},:type => "User"
      end

      it "assigns the requested featured_profile as @featured_profile" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "redirects to all featured_profile" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "User"
        response.should redirect_to(admin_featured_profiles_url)
      end
    end

    describe "with valid params for restaurant " do
      before(:each) do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested featured_profile" do
        FeaturedProfile.expects(:find).with("37").returns(@featured_profile)
        put :update, :id => "37", :featured_profile => {:these => 'params'},:type => "Restaurant"
      end

      it "assigns the requested featured_profile as @featured_profile" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "Restaurant"
        assigns[:feature].should equal(@featured_profile)
      end

      it "redirects to all featured_profile" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "Restaurant"
        response.should redirect_to(admin_featured_profiles_url)
      end
    end

    describe "with invalid params for user " do
      before(:each) do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested featured_profile" do
        FeaturedProfile.expects(:find).with("37").returns(@featured_profile)
        put :update, :id => "37", :featured_profile => {:these => 'params'},:type => "User"
      end

      it "assigns the featured_profile as @featured_profile" do
        put :update, :id => "1",:type => "User"
        assigns[:feature].should equal(@featured_profile)
      end

      it "re-renders the 'edit' template" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "User"
        response.should render_template(:edit)
      end
    end
    describe "with invalid params for restaurant " do
      before(:each) do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        FeaturedProfile.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested featured_profile" do
        FeaturedProfile.expects(:find).with("37").returns(@featured_profile)
        put :update, :id => "37", :featured_profile => {:these => 'params'},:type => "Restaurant"
      end

      it "assigns the featured_profile as @featured_profile" do
        put :update, :id => "1",:type => "Restaurant"
        assigns[:feature].should equal(@featured_profile)
      end

      it "re-renders the 'edit' template" do
        FeaturedProfile.stubs(:find).returns(@featured_profile)
        put :update, :id => "1",:type => "Restaurant"
        response.should render_template(:edit)
      end
    end
  end 


  describe "DELETE destroy" do
    it "destroys the requested featured_profile" do
      FeaturedProfile.expects(:find).with("37").returns(@featured_profile)
      @featured_profile.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the featured_profile list" do
      FeaturedProfile.stubs(:find).returns(@featured_profile)
      delete :destroy, :id => "1"
      @request.accept = "text/javascript"
    end
  end



end
