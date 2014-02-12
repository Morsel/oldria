require_relative '../spec_helper'

describe ALaMinuteAnswersController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
    @restaurant = FactoryGirl.create(:restaurant)
    @employment =  FactoryGirl.create(:employment, :restaurant => @restaurant, :employee => @user)
    @question =  FactoryGirl.create(:a_la_minute_question)
    @a_la_minute_answer = ALaMinuteAnswer.create(:answer => "old answer",:a_la_minute_question => @question,
                                                  :responder => @restaurant)
  end

  describe "GET index" do
    it "assigns all question as @question" do
      get :index,:restaurant_id=>@restaurant.id
      response.should render_template(:index)
    end
  end

  describe "GET bulk_edit" do
    it "assigns all question as @question" do
      get :bulk_edit,:restaurant_id=>@restaurant.id
      response.should render_template(:bulk_edit)
    end
  end

  describe "GET new" do
    it "assigns all question as @question" do
      get :new,:restaurant_id=>@restaurant.id,:question_id=>@question.id
      response.should render_template(:new)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        ALaMinuteAnswer.stubs(:new).returns(@a_la_minute_answer)
        ALaMinuteAnswer.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created a_la_minute_answer as @a_la_minute_answer" do
        post :create, :a_la_minute_answer => {},:question_id=>@question.id,:restaurant_id=>@restaurant.id
        assigns[:answer].should equal(@a_la_minute_answer)
      end

      it "redirects to the created a_la_minute_answer" do
        post :create, :a_la_minute_answer => {}, :a_la_minute_answer => {},:question_id=>@question.id,:restaurant_id=>@restaurant.id
        response.should redirect_to :action => :bulk_edit
      end
    end

    describe "with invalid params" do
      before(:each) do
        ALaMinuteAnswer.any_instance.stubs(:save).returns(false)
        ALaMinuteAnswer.stubs(:new).returns(@a_la_minute_answer)
      end

      it "assigns a newly created but unsaved a_la_minute_answer as @a_la_minute_answer" do
        post :create, :a_la_minute_answer => {:these => 'params'},:question_id=>@question.id,:restaurant_id=>@restaurant.id
        assigns[:answer].should equal(@a_la_minute_answer)
      end

      it "re-renders the 'new' template" do
        post :create, :a_la_minute_answer => {},:question_id=>@question.id,:restaurant_id=>@restaurant.id
        response.should render_template(:action=> "new")
      end
    end
 end

  describe "GET edit" do
    it "assigns the requested a_la_minute_answer as @a_la_minute_answer" do
      ALaMinuteAnswer.stubs(:find).returns(@a_la_minute_answer)
      get :edit, :id => "37",:id=>@a_la_minute_answer.id,:restaurant_id=>@restaurant.id
      assigns[:answer].should equal(@a_la_minute_answer)
    end
  end
 
  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        ALaMinuteAnswer.stubs(:find).returns(@a_la_minute_answer)
        ALaMinuteAnswer.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested a_la_minute_answer" do
        ALaMinuteAnswer.expects(:find).with("37").returns(@a_la_minute_answer)
        put :update, :id => "37", :a_la_minute_answer => {:these => 'params'},:restaurant_id=>@restaurant.id
      end

      it "assigns the requested a_la_minute_answer as @a_la_minute_answer" do
        ALaMinuteAnswer.stubs(:find).returns(@a_la_minute_answer)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        assigns[:answer].should equal(@a_la_minute_answer)
      end

      it "redirects to all a_la_minute_answer" do
        ALaMinuteAnswer.stubs(:find).returns(@a_la_minute_answer)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        response.should redirect_to :action => :bulk_edit
      end
    end

    describe "with invalid params" do
      before(:each) do
        ALaMinuteAnswer.stubs(:find).returns(@a_la_minute_answer)
        ALaMinuteAnswer.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested a_la_minute_answer" do
        ALaMinuteAnswer.expects(:find).with("37").returns(@a_la_minute_answer)
        put :update, :id => "37", :answer => {:these => 'params'},:restaurant_id=>@restaurant.id
      end

      it "assigns the a_la_minute_answer as @a_la_minute_answer" do
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        assigns[:answer].should equal(@a_la_minute_answer)
      end

      it "re-renders the 'edit' template" do
        ALaMinuteAnswer.stubs(:find).returns(@mediafeed_page)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        response.should render_template(:action=> "edit")
      end
    end
  end

  # describe "PUT bulk_update" do
  #   let(:restaurant) { FactoryGirl.create(:restaurant) }
  #   let(:current_user) { FactoryGirl.create(:user) }
  #   let(:question) { FactoryGirl.create(:a_la_minute_question) }

  #   before(:each) do
  #     FactoryGirl.create(:employment, :restaurant => restaurant, :employee => current_user)
  #     controller.stubs(:current_user).returns current_user
  #   end

  #   describe "successful update" do
  #     before(:each) do
  #       previous_answer = ALaMinuteAnswer.create(:answer => "old answer",
  #                                                :a_la_minute_question => question,
  #                                                :responder => restaurant,
  #                                                :created_at => 1.day.ago)

  #       put :update, "restaurant_id" => restaurant.id,"id"=>previous_answer.id,
  #         "a_la_minute_questions" => {
  #           question.id.to_s => {
  #             "answer" => "new answer",
  #             "answer_id" => previous_answer.id
  #           }
  #         }
  #     end

  #     specify { question.should have(1).a_la_minute_answers }
  #     specify { question.reload.answer_for(restaurant).answer.should == "old answer" }
  #     specify { response.should redirect_to(bulk_edit_restaurant_a_la_minute_answers_url(restaurant)) }
  #   end

  #   describe "update if answer doesn't change" do
  #     before(:each) do
  #       previous_answer = FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)

  #       put :update, "restaurant_id" => restaurant.id,"id"=>previous_answer.id,
  #         "a_la_minute_questions" => {
  #           question.id.to_s => {
  #             "answer" => previous_answer.answer,
  #             "answer_id" => previous_answer.id
  #           }
  #         }
  #     end

  #     specify { question.should have(1).a_la_minute_answers }
  #   end

  # end

  # describe "update with cross-posting" do

  #   before(:each) do
  #     @user = FactoryGirl.create(:user)
  #     @restaurant = FactoryGirl.create(:restaurant, :atoken => "qwerty", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
  #     FactoryGirl.create(:employment, :restaurant => @restaurant, :employee => @user)
  #     controller.stubs(:current_user).returns @user
  #   end

  #   it "should crosspost to Twitter" do
  #     twitter_client = mock
  #     # Restaurant.any_instance.expects(:twitter_client).returns(twitter_client)
  #     # twitter_client.expects(:send_at).returns(true)

  #     question = FactoryGirl.create(:a_la_minute_question)
  #     previous_answer = FactoryGirl.create(:a_la_minute_answer, :answer => "old answer", :responder => @restaurant, :a_la_minute_question => question, :created_at => 1.day.ago)

  #     put :update, "restaurant_id" => @restaurant.id,'id'=>previous_answer.id,
  #     "a_la_minute_questions" => {
  #       question.id.to_s => {
  #         "answer" => "new cross-posting answer",
  #         "answer_id" => previous_answer.id,
  #         "post_to_twitter_at" => { :year => "2012", :month => "07", :day => "25", :hour => "6", :minute => "24"}
  #       }
  #     }

  #     question.reload.should have(1).a_la_minute_answers
  #   end

  # end

end
