require 'spec_helper'

describe ALaMinuteAnswer do
  before(:each) do
    @question = Factory(:a_la_minute_question)
    @responder = Factory(:restaurant)
    @valid_attributes = {
      :answer => "value for answer",
      :a_la_minute_question => @question,
      :responder => @restaurant,
      :show_as_public => false
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteAnswer.create!(@valid_attributes)
  end

  it "should reflect the show_as_public state of any previous answer for the same question" do
    restaurant = Factory(:restaurant)
    question = Factory(:a_la_minute_question)
    previous_answer = Factory(:a_la_minute_answer, :a_la_minute_question => question, :responder => restaurant, :show_as_public => true)

    new_answer = ALaMinuteAnswer.create!({
      :answer => "value for answer",
      :a_la_minute_question => question,
      :responder => restaurant
    })

    new_answer.show_as_public.should be_true
  end

  describe "#show_as_public" do
    it "should only find public answers" do
      public_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))
      private_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => false))

      # show_as_public is created automagically by search logic, this test just reinforces this
      ALaMinuteAnswer.show_as_public.all.should == [public_answer]
    end
  end

  describe "#newest" do
    it "should only find the most recent answer for each question" do
      old_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))
      new_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))

      ALaMinuteAnswer.newest.should == [new_answer]
    end
  end

  describe "#public_profile_for=" do
    it "should show the most recent 3 public answers for a given responder" do
      q1 = Factory(:a_la_minute_question)
      q2 = Factory(:a_la_minute_question)
      q3 = Factory(:a_la_minute_question)
      q4 = Factory(:a_la_minute_question)
      ans_1 = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true, :a_la_minute_question => q1, :created_at => 1.week.ago))
      ans_2 = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true, :a_la_minute_question => q2, :created_at => 1.day.ago))
      ans_3 = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true, :a_la_minute_question => q3, :created_at => 3.days.ago))
      ans_4 = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true, :a_la_minute_question => q4, :created_at => 2.days.ago))
      @responder.a_la_minute_answers = [ans_1, ans_2, ans_3, ans_4]
      ALaMinuteAnswer.public_profile_for(@responder).should == [ans_2, ans_4, ans_3]
    end
  end
end
