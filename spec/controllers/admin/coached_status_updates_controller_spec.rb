require_relative '../../spec_helper'

describe Admin::CoachedStatusUpdatesController  do
  integrate_views

  before(:each) do
    @coached_status_update = FactoryGirl.create(:coached_status_update)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all coached_status_update as @coached_status_update" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "assigns all coached_status_update as @coached_status_update" do
      CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
      get :show,:id=>@coached_status_update.id
      response.should render_template(:show)
    end
  end

  describe "GET new" do
    it "assigns a new coached_status_update as @coached_status_update" do
      CoachedStatusUpdate.stubs(:new).returns(@coached_status_update)
      get :new
      assigns[:coached_status_update].should equal(@coached_status_update)
    end
  end

describe "POST create" do

    describe "with valid params" do
      before(:each) do
        CoachedStatusUpdate.stubs(:new).returns(@coached_status_update)
        CoachedStatusUpdate.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created coached_status_update as @coached_status_update" do
        post :create, :coached_status_update => {}
        assigns[:coached_status_update].should equal(@coached_status_update)
      end

      it "redirects to the created coached_status_update" do
        post :create, :coached_status_update => {}
        response.should redirect_to(admin_coached_status_updates_url)
      end
    end
  
    describe "with invalid params" do
      before(:each) do
        CoachedStatusUpdate.any_instance.stubs(:save).returns(false)
        CoachedStatusUpdate.stubs(:new).returns(@coached_status_update)
      end

      it "assigns a newly created but unsaved coached_status_update as @coached_status_update" do
        post :create, :coached_status_update => {:these => 'params'}
        assigns[:coached_status_update].should equal(@coached_status_update)
      end

      it "re-renders the 'new' template" do
        post :create, :coached_status_update => {}
        response.should render_template(:action=> "new")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested coached_status_update as @coached_status_update" do
      CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
      get :edit, :id => "37"
      assigns[:coached_status_update].should equal(@coached_status_update)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
        CoachedStatusUpdate.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested coached_status_update" do
        CoachedStatusUpdate.expects(:find).with("37").returns(@coached_status_update)
        put :update, :id => "37", :coached_status_update => {:these => 'params'}
      end

      it "assigns the requested coached_status_update as @coached_status_update" do
        CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
        put :update, :id => "1"
        assigns[:coached_status_update].should equal(@coached_status_update)
      end

      it "redirects to all coached_status_update" do
        CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
        put :update, :id => "1"
        response.should redirect_to admin_coached_status_updates_path
      end
    end
    describe "with invalid params" do
      before(:each) do
        CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
        CoachedStatusUpdate.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested coached_status_update" do
        CoachedStatusUpdate.expects(:find).with("37").returns(@coached_status_update)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the coached_status_update as @coached_status_update" do
        put :update, :id => "1"
        assigns[:coached_status_update].should equal(@coached_status_update)
      end

      it "re-renders the 'edit' template" do
        CoachedStatusUpdate.stubs(:find).returns(@coached_status_update)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end  

  describe "DELETE destroy" do
    it "destroys the requested coached_status_update" do
      CoachedStatusUpdate.expects(:find).with("37").returns(@coached_status_update)
      @coached_status_update.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(admin_coached_status_updates_path)
    end
  end 


end   