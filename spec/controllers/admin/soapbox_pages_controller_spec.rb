require_relative '../../spec_helper'

describe Admin::SoapboxPagesController do
  integrate_views

  before(:each) do
    @soapbox_page = FactoryGirl.create(:soapbox_page)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all soapbox_page as @soapbox_page" do
      SoapboxPage.stubs(:find).returns([@soapbox_page])
      get :index
      assigns[:pages].should == [@soapbox_page]
    end
  end

  describe "GET new" do
    it "assigns a new soapbox_page as @soapbox_page" do
      SoapboxPage.stubs(:new).returns(@soapbox_page)
      get :new
      assigns[:page].should equal(@soapbox_page)
    end
  end

  describe "GET edit" do
    it "assigns the requested soapbox_page as @soapbox_page" do
      SoapboxPage.stubs(:find).returns(@soapbox_page)
      get :edit, :id => "37"
      assigns[:page].should equal(@soapbox_page)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        SoapboxPage.stubs(:new).returns(@soapbox_page)
        SoapboxPage.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created soapbox_page as @soapbox_page" do
        post :create, :soapbox_page => {}
        assigns[:page].should equal(@soapbox_page)
      end

      it "redirects to the created soapbox_page" do
        post :create, :soapbox_page => {}
        response.should redirect_to(admin_soapbox_pages_path)
      end
    end

	  describe "with invalid params" do
	    before(:each) do
	      SoapboxPage.any_instance.stubs(:save).returns(false)
	      SoapboxPage.stubs(:new).returns(@soapbox_page)
	    end

	    it "assigns a newly created but unsaved soapbox_page as @soapbox_page" do
	      post :create, :soapbox_page => {:these => 'params'}
	      assigns[:page].should equal(@soapbox_page)
	    end

	    it "re-renders the 'new' template" do
	      post :create, :soapbox_page => {}
	      response.should render_template(:action=> "new")
	    end
	  end
  end

 describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        SoapboxPage.stubs(:find).returns(@soapbox_page)
        SoapboxPage.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested soapbox_page" do
        SoapboxPage.expects(:find).with("37").returns(@soapbox_page)
        put :update, :id => "37", :soapbox_page => {:these => 'params'}
      end

      it "assigns the requested soapbox_page as @soapbox_page" do
        SoapboxPage.stubs(:find).returns(@soapbox_page)
        put :update, :id => "1"
        assigns[:page].should equal(@soapbox_page)
      end

      it "redirects to all soapbox_page" do
        SoapboxPage.stubs(:find).returns(@soapbox_page)
        put :update, :id => "1"
        response.should redirect_to admin_soapbox_pages_path(:anchor => "soapbox_page_#{@soapbox_page.id}")
      end
    end

    describe "with invalid params" do
      before(:each) do
        SoapboxPage.stubs(:find).returns(@soapbox_page)
        SoapboxPage.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested soapbox_page" do
        SoapboxPage.expects(:find).with("37").returns(@soapbox_page)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the soapbox_page as @soapbox_page" do
        put :update, :id => "1"
        assigns[:page].should equal(@soapbox_page)
      end

      it "re-renders the 'edit' template" do
        SoapboxPage.stubs(:find).returns(@soapbox_page)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested soapbox_page" do
      SoapboxPage.expects(:find).with("37").returns(@soapbox_page)
      @soapbox_page.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(redirect_to admin_pages_path)
    end
  end   

end
