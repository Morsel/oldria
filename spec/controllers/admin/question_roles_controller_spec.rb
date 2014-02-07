require_relative '../../spec_helper'

describe Admin::QuestionRolesController do
  integrate_views

  before(:each) do
    @question_role = FactoryGirl.create(:question_role)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "assigns a new question_role as @question_role" do
      QuestionRole.stubs(:new).returns(@question_role)
      get :new
      assigns[:role].should equal(@question_role)
    end
  end

    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          QuestionRole.stubs(:new).returns(@question_role)
          QuestionRole.any_instance.stubs(:save).returns(true)
        end

        it "assigns a newly created question_role as @question_role" do
          post :create, :role => {}
          assigns[:role].should equal(@question_role)
        end

        it "redirects to the created question_role" do
          post :create, :role => {}
          response.should redirect_to :action => :new
        end
      end

    describe "with invalid params" do
      before(:each) do
        QuestionRole.any_instance.stubs(:save).returns(false)
        QuestionRole.stubs(:new).returns(@question_role)
      end

      it "assigns a newly created but unsaved question_role as @question_role" do
        post :create, :role => {:these => 'params'}
        assigns[:role].should equal(@question_role)
      end

      it "re-renders the 'new' template" do
        post :create, :role => {}
        response.should render_template(:action=> "new")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested question_role as @question_role" do
      QuestionRole.stubs(:find).returns(@question_role)
      get :edit, :id => "37"
      assigns[:role].should equal(@question_role)
    end
  end
 
  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        QuestionRole.stubs(:find).returns(@question_role)
        QuestionRole.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested question_role" do
        QuestionRole.expects(:find).with("37").returns(@question_role)
        put :update, :id => "37", :question_role => {:these => 'params'}
      end

      it "assigns the requested question_role as @question_role" do
        QuestionRole.stubs(:find).returns(@question_role)
        put :update, :id => "1"
        assigns[:role].should equal(@question_role)
      end

      it "redirects to all question_role" do
        QuestionRole.stubs(:find).returns(@question_role)
        put :update, :id => "1"
        response.should render_template(:action=> "new")
      end
    end

    describe "with invalid params" do
      before(:each) do
        QuestionRole.stubs(:find).returns(@question_role)
        QuestionRole.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested question_role" do
        QuestionRole.expects(:find).with("37").returns(@question_role)
        put :update, :id => "37", :question_role => {:these => 'params'}
      end

      it "assigns the question_role as @question_role" do
        put :update, :id => "1"
        assigns[:role].should equal(@question_role)
      end

      it "re-renders the 'edit' template" do
        QuestionRole.stubs(:find).returns(@question_role)
        put :update, :id => "1"
        response.should redirect_to :action => :new
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question_role" do
      QuestionRole.expects(:find).with("37").returns(@question_role)
      @question_role.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :new
    end
  end



end
