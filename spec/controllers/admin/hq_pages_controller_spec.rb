require_relative '../../spec_helper'

describe Admin::HqPagesController do
  integrate_views

  before(:each) do
    @hq_page = FactoryGirl.create(:hq_page)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all pages as @pages" do
      HqPage.stubs(:find).returns([@hq_page])
      get :index
      assigns[:pages].should == [@hq_page]
    end
  end

  describe "GET new" do
    it "assigns a new pages as @page" do
      HqPage.stubs(:new).returns(@hq_page)
      get :new
      assigns[:page].should equal(@hq_page)
    end
  end

  describe "GET edit" do
    it "assigns the requested page as @page" do
      HqPage.stubs(:find).returns(@hq_page)
      get :edit, :id => "37"
      assigns[:page].should equal(@hq_page)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        HqPage.stubs(:new).returns(@hq_page)
        HqPage.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created page as @page" do
        post :create, :page => {}
        assigns[:page].should equal(@hq_page)
      end

      it "redirects to the created page" do
        post :create, :page => {}
        response.should redirect_to(admin_hq_pages_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        HqPage.any_instance.stubs(:save).returns(false)
        HqPage.stubs(:new).returns(@hq_page)
      end

      it "assigns a newly created but unsaved hq_page as @hq_page" do
        post :create, :hq_page => {:these => 'params'}
        assigns[:page].should equal(@hq_page)
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
        HqPage.stubs(:find).returns(@hq_page)
        HqPage.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested page" do
        HqPage.expects(:find).with("37").returns(@hq_page)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the requested page as @page" do
        HqPage.stubs(:find).returns(@hq_page)
        put :update, :id => "1"
        assigns[:page].should equal(@hq_page)
      end

      it "redirects to all hq pages" do
        HqPage.stubs(:find).returns(@hq_page)
        put :update, :id => "1"
        response.should redirect_to admin_hq_pages_url(:anchor => "hq_page_#{@hq_page.id}")
      end
    end

    describe "with invalid params" do
      before(:each) do
        HqPage.stubs(:find).returns(@hq_page)
        HqPage.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested hq pages" do
        HqPage.expects(:find).with("37").returns(@hq_page)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the page as @page" do
        put :update, :id => "1"
        assigns[:page].should equal(@hq_page)
      end

      it "re-renders the 'edit' template" do
        HqPage.stubs(:find).returns(@hq_page)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end   

  describe "DELETE destroy" do
    it "destroys the requested hq_page" do
      HqPage.expects(:find).with("37").returns(@hq_page)
      @hq_page.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the hq_page list" do
      HqPage.stubs(:find).returns(@hq_page)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_hq_pages_url)
    end
  end

 
end
