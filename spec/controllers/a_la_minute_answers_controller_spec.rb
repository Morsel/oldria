require 'spec_helper'

describe ALaMinuteAnswersController do
  include ActionView::Helpers::RecordIdentificationHelper

  let(:restaurant) { Factory(:restaurant, :id => 1) }
  let(:question) { Factory(:a_la_minute_question, :id => 1) }
  let(:current_user) { Factory(:user) }

  before(:each) do
    Factory(:employment, :restaurant => restaurant, :employee => current_user)
    controller.stubs(:current_user).returns current_user
  end

  describe "PUT bulk_update" do
    describe "successful update" do
      before(:each) do
        answer = ALaMinuteAnswer.create(:answer => "old answer",
            :a_la_minute_question => question, :responder => restaurant,
            :created_at => 1.day.ago, :show_as_public => false)

        put :bulk_update, "restaurant_id" => restaurant.id,
          "a_la_minute_questions" => {
            question.id.to_s => {
              "answer" => "new answer",
              "old_answer" => "old answer"
            }
          }
      end

      specify { question.should have(2).a_la_minute_answers}
      specify { question.answer_for(restaurant).answer.should == "new answer" }
      specify { question.answer_for(restaurant).show_as_public.should be_false }
      specify { response.should redirect_to(bulk_edit_restaurant_a_la_minute_answers_path(restaurant)) }
    end

    describe "update if answer doesn't change" do
      before(:each) do
        answer = ALaMinuteAnswer.create(:answer => "old answer",
            :a_la_minute_question => question, :responder => restaurant)
        put :bulk_update, "restaurant_id" => restaurant.id,
          "a_la_minute_questions" => {
            question.id.to_s => {
              "answer" => "old answer",
              "old_answer" => "old answer",
              "show_as_public" => "1"
            }
          }
      end

      specify { question.should have(1).a_la_minute_answers}
      specify { question.answer_for(restaurant).show_as_public.should be_true }
    end

  end

end
