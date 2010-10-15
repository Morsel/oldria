require 'spec_helper'

describe ALaMinuteAnswersController do
  include ActionView::Helpers::RecordIdentificationHelper

  let(:restaurant) { Factory(:restaurant, :id => 1) }
  let(:question) { Factory(:a_la_minute_question, :id => 1) }

  describe "PUT bulk_update" do
    describe "successful update" do
      before(:each) do
        put :bulk_update, "restaurant_id" => restaurant.id,
          "a_la_minute_questions" => {
            question.id.to_s => {
              "answer" => "new answer",
              "old_answer" => "old answer"
            }
          }
      end

      specify { question.answer_for(restaurant).answer.should == "new answer" }
      specify { response.should redirect_to(bulk_edit_restaurant_a_la_minute_answers_path(restaurant)) }
    end
  end

  describe "POST edit_in_place" do

    describe "successful update" do
      before(:each) do
        post :edit_in_place, "new_value" => "What's new",
            "data" => "restaurant_id=#{restaurant.id}",
            "id" => dom_id(question), "orig_value"=> "Pretty"
        @answer = assigns[:answer]
      end

      it "should return the new text on successful update" do
        ActiveSupport::JSON.decode(response.body) == {"is_error" => false,
            "error_text" => nil, "html" => "What's new"}
      end

      specify { @answer.a_la_minute_question.should == question }
      specify { @answer.responder.should == restaurant }
      specify { @answer.answer.should == "What's new" }
    end

    describe "unsuccessful update" do
      before(:each) do
        post :edit_in_place, "new_value" => "What's new",
            "data" => "restaurant_id=#{restaurant.id + 1}",
            "id" => dom_id(question), "orig_value"=> "Pretty"
        @answer = assigns[:answer]
      end

      it "should return the new text on successful update" do
        ActiveSupport::JSON.decode(response.body).should == {"is_error" => true,
            "error_text" => "Error updating answer", "html" => "Pretty"}
      end
    end

  end
end