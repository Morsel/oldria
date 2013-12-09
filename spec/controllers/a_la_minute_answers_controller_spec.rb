require_relative '../spec_helper'

describe ALaMinuteAnswersController do
  # include ActionView::Helpers::RecordIdentificationHelper

  describe "PUT bulk_update" do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:current_user) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:a_la_minute_question) }

    before(:each) do
      FactoryGirl.create(:employment, :restaurant => restaurant, :employee => current_user)
      controller.stubs(:current_user).returns current_user
    end

    describe "successful update" do
      before(:each) do
        previous_answer = ALaMinuteAnswer.create(:answer => "old answer",
                                                 :a_la_minute_question => question,
                                                 :responder => restaurant,
                                                 :created_at => 1.day.ago)

        put :update, "restaurant_id" => restaurant.id,"id"=>previous_answer.id,
          "a_la_minute_questions" => {
            question.id.to_s => {
              "answer" => "new answer",
              "answer_id" => previous_answer.id
            }
          }
      end

      specify { question.should have(1).a_la_minute_answers }
      specify { question.reload.answer_for(restaurant).answer.should == "old answer" }
      specify { response.should redirect_to(bulk_edit_restaurant_a_la_minute_answers_url(restaurant)) }
    end

    describe "update if answer doesn't change" do
      before(:each) do
        previous_answer = FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)

        put :update, "restaurant_id" => restaurant.id,"id"=>previous_answer.id,
          "a_la_minute_questions" => {
            question.id.to_s => {
              "answer" => previous_answer.answer,
              "answer_id" => previous_answer.id
            }
          }
      end

      specify { question.should have(1).a_la_minute_answers }
    end

  end

  describe "update with cross-posting" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @restaurant = FactoryGirl.create(:restaurant, :atoken => "qwerty", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
      FactoryGirl.create(:employment, :restaurant => @restaurant, :employee => @user)
      controller.stubs(:current_user).returns @user
    end

    it "should crosspost to Twitter" do
      twitter_client = mock
      # Restaurant.any_instance.expects(:twitter_client).returns(twitter_client)
      # twitter_client.expects(:send_at).returns(true)

      question = FactoryGirl.create(:a_la_minute_question)
      previous_answer = FactoryGirl.create(:a_la_minute_answer, :answer => "old answer", :responder => @restaurant, :a_la_minute_question => question, :created_at => 1.day.ago)

      put :update, "restaurant_id" => @restaurant.id,'id'=>previous_answer.id,
      "a_la_minute_questions" => {
        question.id.to_s => {
          "answer" => "new cross-posting answer",
          "answer_id" => previous_answer.id,
          "post_to_twitter_at" => { :year => "2012", :month => "07", :day => "25", :hour => "6", :minute => "24"}
        }
      }

      question.reload.should have(1).a_la_minute_answers
    end

  end

end
