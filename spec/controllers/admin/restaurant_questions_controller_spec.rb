require_relative '../../spec_helper'

describe Admin::RestaurantQuestionsController do

  integrate_views

  before(:each) do
    @question = FactoryGirl.create(:restaurant_question)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    it "assigns a new questions as @questions" do
      RestaurantQuestion.stubs(:new).returns(@question)
      get :new
      assigns[:question].should equal(@question)
    end
  end

  describe "POST create" do

	    describe "with valid params" do
	      before(:each) do
	        RestaurantQuestion.stubs(:new).returns(@question)
	        RestaurantQuestion.any_instance.stubs(:save).returns(true)
	      end

	      it "assigns a newly created questions as @questions" do
	        post :create, :question => {}
	        assigns[:question].should equal(@question)
	      end

	      it "redirects to the created questions" do
	        post :create, :question => {}
	        response.should redirect_to :action => :index
	      end
	    end
	    describe "with invalid params" do
	    before(:each) do
	      RestaurantQuestion.any_instance.stubs(:save).returns(false)
	      RestaurantQuestion.stubs(:new).returns(@question)
	    end

	    it "assigns a newly created but unsaved question as @question" do
	      post :create, :question => {:these => 'params'}
	      assigns[:question].should equal(@question)
	    end

	    it "re-renders the 'new' template" do
	      post :create, :question => {}
	      response.should render_template(:action=> "new")
	    end
	  end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        RestaurantQuestion.stubs(:find).returns(@question)
        RestaurantQuestion.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested question" do
        RestaurantQuestion.expects(:find).with("37").returns(@question)
        put :update, :id => "37", :question => {:these => 'params'}
      end

      it "assigns the requested question as @question" do
        RestaurantQuestion.stubs(:find).returns(@question)
        put :update, :id => "1"
        assigns[:question].should equal(@question)
      end

      it "redirects to all question" do
        RestaurantQuestion.stubs(:find).returns(@question)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        RestaurantQuestion.stubs(:find).returns(@question)
        RestaurantQuestion.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested question" do
        RestaurantQuestion.expects(:find).with("37").returns(@question)
        put :update, :id => "37", :question => {:these => 'params'}
      end

      it "assigns the question as @question" do
        put :update, :id => "1"
        assigns[:question].should equal(@question)
      end

      it "re-renders the 'edit' template" do
        RestaurantQuestion.stubs(:find).returns(@question)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      RestaurantQuestion.expects(:find).with("37").returns(@question)
      @question.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end

  describe "send_notifications" do
    it "send_notifications mails" do
      RestaurantQuestion.expects(:find).with("37").returns(@question)
      get :send_notifications, :id => @question.id
      flash.should_not be_nil
      response.should redirect_to :action => :index
    end
  end

  describe "sort" do
    it "sort" do
      RestaurantQuestion.expects(:find).with("37").returns(@question)
      get :sort
      response.body.should be_blank
    end
  end

end
