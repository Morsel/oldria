require_relative '../../spec_helper'

describe Admin::SfSlidesController do

 integrate_views

  before(:each) do
    @sf_slide = FactoryGirl.create(:sf_slide)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all sf_slide as @sf_slide" do
      SfSlide.stubs(:find).returns([@sf_slide])
      get :index
      assigns[:slides].should == [@sf_slide]
    end
  end


  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        SfSlide.stubs(:new).returns(@sf_slide)
        SfSlide.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created sf_slide as @sf_slide" do
        post :create, :slide => {}
        assigns[:slide].should equal(@sf_slide)
      end

      it "redirects to the created sf_slide" do
        post :create, :slide => {}
        response.should redirect_to :action => :index
      end
    end
  end 

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        SfSlide.stubs(:find).returns(@sf_slide)
        SfSlide.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested sf_slide" do
        SfSlide.expects(:find).with("37").returns(@sf_slide)
        put :update, :id => "37", :slide => {:these => 'params'}
      end

      it "assigns the requested sf_slide as @sf_slide" do
        SfSlide.stubs(:find).returns(@sf_slide)
        put :update, :id => "1"
        assigns[:slide].should equal(@sf_slide)
      end

      it "redirects to all sf_slide" do
        SfSlide.stubs(:find).returns(@sf_slide)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end
  end 

  describe "DELETE destroy" do
    it "destroys the requested sf_slide" do
      SfSlide.expects(:find).with("37").returns(@sf_slide)
      @sf_slide.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end

  it "sort" do
    get :create
    response.should render_template(:new)
  end
    

end
