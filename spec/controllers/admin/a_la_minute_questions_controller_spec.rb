require_relative '../../spec_helper'

describe Admin::ALaMinuteQuestionsController do
  include ActionController::RecordIdentifier

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "POST edit_in_place" do

    let(:question) { FactoryGirl.create(:a_la_minute_question, :id => 1) }

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
end