require_relative '../../spec_helper'

describe Admin::TopicsController do
  integrate_views

  before(:each) do
    @topic = FactoryGirl.create(:topic)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all topic as @topic" do
      Topic.stubs(:find).returns([@topic])
      get :index
      assigns[:topics].should == [@topic]
      response.should render_template(:index)
    end
  end

 describe "GET new" do
    it "assigns a new topic as @topic" do
      Topic.stubs(:new).returns(@topic)
      get :new
      assigns[:topic].should equal(@topic)
      response.should render_template(:action=> "edit")
    end
  end

 describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Topic.stubs(:new).returns(@topic)
        Topic.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created topic as @topic" do
        post :create, :topic => {}
        assigns[:topic].should equal(@topic)
      end

      it "redirects to the created topic" do
        post :create, :topic => {}
        response.should redirect_to :action => :index
      end
    end
	  describe "with invalid params" do
	    before(:each) do
	      Topic.any_instance.stubs(:save).returns(false)
	      Topic.stubs(:new).returns(@topic)
	    end

	    it "assigns a newly created but unsaved topic as @topic" do
	      post :create, :topic => {:these => 'params'}
	      assigns[:topic].should equal(@topic)
	    end

	    it "re-renders the 'new' template" do
	      post :create, :topic => {}
	      response.should render_template(:action=> "edit")
	    end
	  end
	 end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Topic.stubs(:find).returns(@topic)
        Topic.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested topic" do
        Topic.expects(:find).with("37").returns(@topic)
        put :update, :id => "37", :topic => {:these => 'params'}
      end

      it "assigns the requested topic as @topic" do
        Topic.stubs(:find).returns(@topic)
        put :update, :id => "1"
        assigns[:topic].should equal(@topic)
      end

      it "redirects to all topic" do
        Topic.stubs(:find).returns(@topic)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        Topic.stubs(:find).returns(@topic)
        Topic.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested topic" do
        Topic.expects(:find).with("37").returns(@topic)
        put :update, :id => "37", :topic => {:these => 'params'}
      end

      it "assigns the topic as @topic" do
        put :update, :id => "1"
        assigns[:topic].should equal(@topic)
      end

      it "re-renders the 'edit' template" do
        Topic.stubs(:find).returns(@topic)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested topic" do
      Topic.expects(:find).with("37").returns(@topic)
      @topic.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end




end
