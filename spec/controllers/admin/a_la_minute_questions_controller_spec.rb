require_relative '../../spec_helper'

describe Admin::ALaMinuteQuestionsController do
  include ActionController::RecordIdentifier

  before(:each) do
    @a_la_minute_question = FactoryGirl.create(:a_la_minute_question)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "POST edit_in_place" do

    let(:question) { FactoryGirl.create(:a_la_minute_question, :id => 2) }

    describe "successful update" do
      before(:each) do
        post :edit_in_place, "new_value" => "What's new",
            "id" => dom_id(question), "orig_value"=> "Pretty"
        @question = assigns[:question]
      end

      it "should return the new text on successful update" do
        ActiveSupport::JSON.decode(response.body) == {"is_error" => false,
            "error_text" => nil, "html" => "What's new"}
      end

      specify { @question.question.should == "What's new" }
    end
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      get :index
      @questions = ALaMinuteQuestion.restaurants
      assigns[:questions].should == @questions
      response.should render_template(:index)   
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        ALaMinuteQuestion.stubs(:new).returns(@a_la_minute_question)
        ALaMinuteQuestion.any_instance.stubs(:save).returns(true)
      end
      it "assigns a newly created a_la_minute_question as @a_la_minute_question" do
        post :create, :a_la_minute_question => {}
        assigns[:question].should equal(@a_la_minute_question)
      end
      it "redirects to the created a_la_minute_question" do
        post :create, :a_la_minute_question => {}
        response.should redirect_to :action => :index
      end  
    end  
    describe "with invalid params" do
      before(:each) do
        ALaMinuteQuestion.any_instance.stubs(:save).returns(false)
        ALaMinuteQuestion.stubs(:new).returns(@a_la_minute_question)
      end
      it "assigns a newly created but unsaved question as @question" do
        post :create, :a_la_minute_question => {:these => 'params'}
        assigns[:question].should equal(@a_la_minute_question)
      end
      it "re-renders the 'index' template" do
        post :create, :a_la_minute_question => {}
        response.should redirect_to :action => :index
      end
    end     
  end 

  describe "DELETE destroy" do
    it "destroys the requested a_la_minute_question" do
      ALaMinuteQuestion.expects(:find).with("37").returns(@a_la_minute_question)
      @a_la_minute_question.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end   

  describe "edit_in_place" do
    it "edit_in_place" do
     get :edit_in_place, :id => @a_la_minute_question.id
     response.body.should == {:is_error => true, :error_text => "Error updating answer",:html => nil}.to_json
    end
  end


end