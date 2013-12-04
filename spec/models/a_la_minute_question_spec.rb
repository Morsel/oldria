require_relative '../spec_helper'

describe ALaMinuteQuestion do
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:question) { FactoryGirl.create(:a_la_minute_question) }

  before(:each) do
    @valid_attributes = {
      :question => 'value for question',
      :kind => 'restaurant'
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteQuestion.create!(@valid_attributes)
  end

  it "should correctly identify restaurant types" do
    restaurant_question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
    user_question = FactoryGirl.create(:a_la_minute_question, :kind => 'user')
    ALaMinuteQuestion.restaurants.all.should == [restaurant_question]
  end

  it "finds an answer given a restaurant" do
    question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
    restaurant = FactoryGirl.create(:restaurant)
    answer = FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
    question.answer_for(restaurant).should == answer
  end

  context "when destroying" do
    it "should remove all answers it's answers" do
      FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
      FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
      question_id = question.id

      question.destroy

      ALaMinuteAnswer.find_all_by_a_la_minute_question_id(question_id).should be_empty
    end
  end
end

