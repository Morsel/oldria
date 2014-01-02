require_relative '../../spec_helper'

describe Admin::DateRangesController do
  integrate_views

  before(:each) do
    @date_range = FactoryGirl.create(:date_range)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all date_ranges as @date_ranges" do
      DateRange.stubs(:find).returns([@date_range])
      get :index
      assigns[:date_ranges].should == [@date_range]
    end
  end

  describe "GET new" do
    it "assigns a new date_range as @date_range" do
      DateRange.stubs(:new).returns(@date_range)
      get :new
      assigns[:date_range].should equal(@date_range)
    end
  end

  describe "GET edit" do
    it "assigns the requested date_range as @date_range" do
      DateRange.stubs(:find).returns(@date_range)
      get :edit, :id => "37"
      assigns[:date_range].should equal(@date_range)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        DateRange.stubs(:new).returns(@date_range)
        DateRange.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created date_range as @date_range" do
        post :create, :date_range => {}
        assigns[:date_range].should equal(@date_range)
      end

      it "redirects to the created date_range" do
        post :create, :date_range => {}
        response.should redirect_to(admin_date_ranges_url)
      end
    end
    describe "with invalid params" do
      before(:each) do
        DateRange.any_instance.stubs(:save).returns(false)
        DateRange.stubs(:new).returns(@date_range)
      end

      it "assigns a newly created but unsaved date_range as @date_range" do
        post :create, :date_range => {:these => 'params'}
        assigns[:date_range].should equal(@date_range)
      end

      it "re-renders the 'new' template" do
        post :create, :date_range => {}
        response.should render_template('new')
      end
    end  
  end   

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        DateRange.stubs(:find).returns(@date_range)
        DateRange.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested date_range" do
        DateRange.expects(:find).with("37").returns(@date_range)
        put :update, :id => "37", :date_range => {:these => 'params'}
      end

      it "assigns the requested date_range as @date_range" do
        DateRange.stubs(:find).returns(@date_range)
        put :update, :id => "1"
        assigns[:date_range].should equal(@date_range)
      end

      it "redirects to all date_range" do
        DateRange.stubs(:find).returns(@date_range)
        put :update, :id => "1"
        response.should redirect_to(admin_date_ranges_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        DateRange.stubs(:find).returns(@date_range)
        DateRange.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested date_range" do
        DateRange.expects(:find).with("37").returns(@date_range)
        put :update, :id => "37", :date_range => {:these => 'params'}
      end

      it "assigns the date_range as @date_range" do
        put :update, :id => "1"
        assigns[:date_range].should equal(@date_range)
      end

      it "re-renders the 'edit' template" do
        DateRange.stubs(:find).returns(@date_range)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested date_range" do
      DateRange.expects(:find).with("37").returns(@date_range)
      @date_range.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the date_range list" do
      DateRange.stubs(:find).returns(@date_range)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_date_ranges_url)
    end
  end
  
end
