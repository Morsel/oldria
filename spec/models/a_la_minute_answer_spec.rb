require 'spec_helper'

describe ALaMinuteAnswer do
  before(:each) do
    @valid_attributes = {
      :answer => "value for answer",
      :a_la_minute_question_id => 1,
      :responder_id => 1,
      :responder_type => "value for responder_type",
      :show_as_public => true
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteAnswer.create!(@valid_attributes)
  end

  describe "show_as_public" do
    it "should only find public answers" do
      public_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))
      private_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => false))

      # show_as_public is created automagically by search logic, this test just reinforces this
      ALaMinuteAnswer.show_as_public.all.should == [public_answer]
    end
  end

  describe "newest" do
    it "should only find the most recent answer for each question" do
      old_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))
      new_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:show_as_public => true))

      ALaMinuteAnswer.newest.should == [new_answer]
    end
  end
end
