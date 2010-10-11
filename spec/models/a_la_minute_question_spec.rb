require 'spec_helper'

describe ALaMinuteQuestion do
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
    restaurant = Factory(:a_la_minute_question, :kind => 'restaurant')
    user = Factory(:a_la_minute_question, :kind => 'user')
    ALaMinuteQuestion.restaurants.all.should == [restaurant]
  end

  it "finds an answer given a restaurant" do
    question = Factory(:a_la_minute_question, :kind => 'restaurant')
    restaurant = Factory(:restaurant)
    answer = Factory(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
    question.answer_for(restaurant).should == answer
  end
end
