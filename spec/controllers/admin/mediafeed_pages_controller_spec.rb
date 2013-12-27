require_relative '../../spec_helper'

describe Admin::MediafeedPagesController do
  integrate_views

  before(:each) do
    @mediafeed_page = FactoryGirl.create(:mediafeed_page)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all mediafeed_pages as @mediafeed_page" do
      MediafeedPage.stubs(:find).returns([@mediafeed_page])
      get :index
      assigns[:pages].should == [@mediafeed_page]
    end
  end

  describe "GET new" do
    it "assigns a new mediafeed_page as @mediafeed_page" do
      MediafeedPage.stubs(:new).returns(@mediafeed_page)
      get :new
      assigns[:page].should equal(@mediafeed_page)
    end
  end

  describe "GET edit" do
    it "assigns the requested mediafeed_page as @mediafeed_page" do
      MediafeedPage.stubs(:find).returns(@mediafeed_page)
      get :edit, :id => "37"
      assigns[:page].should equal(@mediafeed_page)
    end
  end
 
  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        MediafeedPage.stubs(:new).returns(@mediafeed_page)
        MediafeedPage.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created mediafeed_page as @mediafeed_page" do
        post :create, :page => {}
        assigns[:page].should equal(@mediafeed_page)
      end

      it "redirects to the created mediafeed_page" do
        post :create, :page => {}
        response.should redirect_to(admin_mediafeed_pages_url)
      end
    end

  describe "with invalid params" do
    before(:each) do
      MediafeedPage.any_instance.stubs(:save).returns(false)
      MediafeedPage.stubs(:new).returns(@mediafeed_page)
    end

    it "assigns a newly created but unsaved mediafeed_page as @mediafeed_page" do
      post :create, :page => {:these => 'params'}
      assigns[:page].should equal(@mediafeed_page)
    end

    it "re-renders the 'new' template" do
      post :create, :page => {}
      response.should render_template('new')
    end
  end
 end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        MediafeedPage.stubs(:find).returns(@mediafeed_page)
        MediafeedPage.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested mediafeed_page" do
        MediafeedPage.expects(:find).with("37").returns(@mediafeed_page)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the requested mediafeed_page as @mediafeed_page" do
        MediafeedPage.stubs(:find).returns(@mediafeed_page)
        put :update, :id => "1"
        assigns[:page].should equal(@mediafeed_page)
      end

      it "redirects to all mediafeed_page" do
        MediafeedPage.stubs(:find).returns(@mediafeed_page)
        put :update, :id => "1"
        response.should redirect_to admin_mediafeed_pages_url(:anchor => "mediafeed_page_#{@mediafeed_page.id}")
      end
    end

    describe "with invalid params" do
      before(:each) do
        MediafeedPage.stubs(:find).returns(@mediafeed_page)
        MediafeedPage.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested mediafeed_page" do
        MediafeedPage.expects(:find).with("37").returns(@mediafeed_page)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the mediafeed_page as @mediafeed_page" do
        put :update, :id => "1"
        assigns[:page].should equal(@mediafeed_page)
      end

      it "re-renders the 'edit' template" do
        MediafeedPage.stubs(:find).returns(@mediafeed_page)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested mediafeed_page" do
      MediafeedPage.expects(:find).with("37").returns(@mediafeed_page)
      @mediafeed_page.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the mediafeed_page list" do
      MediafeedPage.stubs(:find).returns(@mediafeed_page)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_mediafeed_pages_url)
    end
  end

end
