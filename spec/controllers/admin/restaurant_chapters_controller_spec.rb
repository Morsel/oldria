require_relative '../../spec_helper'

describe Admin::RestaurantChaptersController do
  integrate_views

  before(:each) do
    @chapter = FactoryGirl.create(:chapter)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "Get index" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Chapter.stubs(:new).returns(@chapter)
        Chapter.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created chapter as @chapter" do
        post :create, :page => {}
        assigns[:chapter].should equal(@chapter)
      end

      it "redirects to the created chapter" do
        post :create, :chapter => {}
        response.should redirect_to :action => :index
      end
    end

  describe "with invalid params" do
    before(:each) do
      Chapter.any_instance.stubs(:save).returns(false)
      Chapter.stubs(:new).returns(@chapter)
    end

    it "assigns a newly created but unsaved chapter as @chapter" do
      post :create, :page => {:these => 'params'}
      assigns[:chapter].should equal(@chapter)
    end

    it "re-renders the 'new' template" do
      post :create, :chapter => {}
      response.should render_template(:action=> "edit")
    end
  end
end

  describe "GET edit" do
    it "assigns the requested chapter as @chapter" do
      Chapter.stubs(:find).returns(@chapter)
      get :edit, :id => "37"
      assigns[:chapter].should equal(@chapter)
    end
  end


describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Chapter.stubs(:find).returns(@chapter)
        Chapter.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested chapter" do
        Chapter.expects(:find).with("37").returns(@chapter)
        put :update, :id => "37", :chapter => {:these => 'params'}
      end

      it "assigns the requested chapter as @chapter" do
        Chapter.stubs(:find).returns(@chapter)
        put :update, :id => "1"
        assigns[:chapter].should equal(@chapter)
      end

      it "redirects to all chapter" do
        Chapter.stubs(:find).returns(@chapter)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        Chapter.stubs(:find).returns(@chapter)
        Chapter.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested chapter" do
        Chapter.expects(:find).with("37").returns(@chapter)
        put :update, :id => "37", :chapter => {:these => 'params'}
      end

      it "assigns the chapter as @chapter" do
        put :update, :id => "1"
        assigns[:chapter].should equal(@chapter)
      end

      it "re-renders the 'edit' template" do
        Chapter.stubs(:find).returns(@chapter)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested chapter" do
      Chapter.expects(:find).with("37").returns(@chapter)
      @chapter.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end   

  describe "select" do
    it "Work for select" do
      @restaurant_topic = FactoryGirl.create(:restaurant_topic)
      get :select, :id => @restaurant_topic.id
      response.should render_template(:action=> "update")
    end
  end   

 
end
