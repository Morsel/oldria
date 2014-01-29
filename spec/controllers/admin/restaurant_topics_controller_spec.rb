require_relative '../../spec_helper'

describe Admin::RestaurantTopicsController do
  integrate_views

  before(:each) do
    @topics = FactoryGirl.create(:restaurant_topic)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all topics as @topics" do
      RestaurantTopic.stubs(:find).returns([@topics])
      get :index
      assigns[:topics].should == [@topics]
    end
  end

  describe "GET new" do
    it "assigns a new topics as @topics" do
      RestaurantTopic.stubs(:new).returns(@topics)
      get :new
      assigns[:topic].should equal(@topics)
      response.should render_template(:action=> "edit")
    end
  end

  describe "GET edit" do
    it "assigns the requested topics as @topics" do
      RestaurantTopic.stubs(:find).returns(@topics)
      get :edit, :id => "37"
      assigns[:topic].should equal(@topics)
    end
  end  

  describe "GET show" do
    it "assigns the requested topics as @topics" do
      RestaurantTopic.stubs(:find).returns(@topics)
      get :show, :id => @topics.id
      response.should redirect_to :action => :edit,:id => @topics.id
    end
  end   

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        RestaurantTopic.stubs(:new).returns(@topics)
        RestaurantTopic.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created topics as @topics" do
        post :create, :topics => {}
        assigns[:topic].should equal(@topics)
      end

      it "redirects to the created topics" do
        post :create, :topics => {}
        response.should redirect_to :action => :index
      end
    end

  describe "with invalid params" do
    before(:each) do
      RestaurantTopic.any_instance.stubs(:save).returns(false)
      RestaurantTopic.stubs(:new).returns(@topics)
    end

    it "assigns a newly created but unsaved topics as @topics" do
      post :create, :topics => {:these => 'params'}
      assigns[:topic].should equal(@topics)
    end

    it "re-renders the 'new' template" do
      post :create, :topics => {}
      response.should render_template(:action=> "edit")
    end
  end
end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        RestaurantTopic.stubs(:find).returns(@topic)
        RestaurantTopic.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested topics" do
        RestaurantTopic.expects(:find).with("37").returns(@topics)
        put :update, :id => "37", :topic => {:these => 'params'}
      end

      it "assigns the requested topics as @topics" do
        RestaurantTopic.stubs(:find).returns(@topics)
        put :update, :id => "1"
        assigns[:topic].should equal(@topics)
      end

      it "redirects to all topics" do
        RestaurantTopic.stubs(:find).returns(@topics)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        RestaurantTopic.stubs(:find).returns(@topics)
        RestaurantTopic.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested topics" do
        RestaurantTopic.expects(:find).with("37").returns(@topics)
        put :update, :id => "37", :topic => {:these => 'params'}
      end

      it "assigns the topics as @topics" do
        put :update, :id => "1"
        assigns[:topic].should equal(@topics)
      end

      it "re-renders the 'edit' template" do
        RestaurantTopic.stubs(:find).returns(@topics)
        put :update, :id => "1"
       response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested topics" do
      RestaurantTopic.expects(:find).with("37").returns(@topics)
      @topics.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end



end
