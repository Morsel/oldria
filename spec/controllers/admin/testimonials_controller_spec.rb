require_relative '../../spec_helper'

describe Admin::TestimonialsController do
 integrate_views

  before(:each) do
    @testimonial = FactoryGirl.create(:testimonial)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all testimonial as @testimonial" do
      Testimonial.stubs(:find).returns([@testimonial])
      get :index
      assigns[:testimonials].should == [@testimonial]
    end
  end

  describe "GET new" do
    it "assigns a new testimonial as @testimonial" do
      Testimonial.stubs(:new).returns(@testimonial)
      get :new
      assigns[:testimonial].should equal(@testimonial)
    end
  end

  describe "GET edit" do
    it "assigns the requested testimonial as @testimonial" do
      Testimonial.stubs(:find).returns(@testimonial)
      get :edit, :id => "37"
      assigns[:testimonial].should equal(@testimonial)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Testimonial.stubs(:new).returns(@testimonial)
        Testimonial.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created testimonial as @testimonial" do
        post :create, :testimonial => {}
        assigns[:testimonial].should equal(@testimonial)
      end

      it "redirects to the created testimonial" do
        post :create, :testimonial => {}
        response.should redirect_to :action => :index
      end
    end

  describe "with invalid params" do
    before(:each) do
      Testimonial.any_instance.stubs(:save).returns(false)
      Testimonial.stubs(:new).returns(@testimonial)
    end

    it "assigns a newly created but unsaved testimonial as @testimonial" do
      post :create, :testimonial => {:these => 'params'}
      assigns[:testimonial].should equal(@testimonial)
    end

    it "re-renders the 'new' template" do
      post :create, :testimonial => {}
      response.should render_template(:action=> "edit")
    end
  end
 end


  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Testimonial.stubs(:find).returns(@testimonial)
        Testimonial.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested testimonial" do
        Testimonial.expects(:find).with("37").returns(@testimonial)
        put :update, :id => "37", :testimonial => {:these => 'params'}
      end

      it "assigns the requested testimonial as @testimonial" do
        Testimonial.stubs(:find).returns(@testimonial)
        put :update, :id => "1"
        assigns[:testimonial].should equal(@testimonial)
      end

      it "redirects to all testimonial" do
        Testimonial.stubs(:find).returns(@testimonial)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        Testimonial.stubs(:find).returns(@testimonial)
        Testimonial.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested testimonial" do
        Testimonial.expects(:find).with("37").returns(@testimonial)
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "assigns the testimonial as @testimonial" do
        put :update, :id => "1"
        assigns[:testimonial].should equal(@testimonial)
      end

      it "re-renders the 'edit' template" do
        Testimonial.stubs(:find).returns(@testimonial)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested testimonial" do
      Testimonial.expects(:find).with("37").returns(@testimonial)
      @testimonial.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end   




end
