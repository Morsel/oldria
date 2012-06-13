require 'spec_helper'

describe ALaMinuteAnswer do
  before(:each) do
    @question = Factory(:a_la_minute_question)
    @responder = Factory(:restaurant)
    @valid_attributes = {
      :answer => "value for answer",
      :a_la_minute_question => @question,
      :responder => @restaurant,
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteAnswer.create!(@valid_attributes)
  end

  describe "#newest_for" do
    context "for responders" do
      it "should only find the most recent answer for each question" do
        old_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => @responder, :created_at => 4.hours.ago))
        new_answer = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => @responder, :created_at => 2.hours.ago))

        ALaMinuteAnswer.newest_for(@responder).should == [new_answer]
      end
    end
    context "for questions" do
      it "should only find the most recent answers for each restaurant" do
        responder_1 = Factory(:restaurant)
        responder_2 = Factory(:restaurant)

        old_answer_1 = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => responder_1, :created_at => 4.hours.ago))
        new_answer_1 = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => responder_1, :created_at => 3.hours.ago))
        old_answer_2 = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => responder_2, :created_at => 2.hours.ago))
        new_answer_2 = ALaMinuteAnswer.create!(@valid_attributes.merge(:responder => responder_2, :created_at => 1.hours.ago))

        ALaMinuteAnswer.newest_for(@question).should == [new_answer_2, new_answer_1]
      end
    end
  end

  describe "#public_profile_for=" do
    it "should show all public answers for a given responder" do
      q1 = Factory(:a_la_minute_question)
      q2 = Factory(:a_la_minute_question)
      q3 = Factory(:a_la_minute_question)
      q4 = Factory(:a_la_minute_question)
      ans_1 = ALaMinuteAnswer.create!(@valid_attributes.merge(:a_la_minute_question => q1, :created_at => 1.week.ago))
      ans_2 = ALaMinuteAnswer.create!(@valid_attributes.merge(:a_la_minute_question => q2, :created_at => 1.day.ago))
      ans_3 = ALaMinuteAnswer.create!(@valid_attributes.merge(:a_la_minute_question => q3, :created_at => 3.days.ago))
      ans_4 = ALaMinuteAnswer.create!(@valid_attributes.merge(:a_la_minute_question => q4, :created_at => 2.days.ago))
      @responder.a_la_minute_answers = [ans_1, ans_2, ans_3, ans_4]
      ALaMinuteAnswer.public_profile_for(@responder).should == [ans_2, ans_4, ans_3, ans_1]
    end
  end

  describe "#archived_for" do
    it "should return all archived answers for the question" do
      q1 = Factory(:a_la_minute_question)
      ans_1 = Factory(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 1.day.ago)
      ans_2 = Factory(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 3.day.ago)
      ans_3 = Factory(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 2.day.ago)
      ans_4 = Factory(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 1.hour.ago)
      ALaMinuteAnswer.archived_for(q1).should == [ans_1, ans_3, ans_2]
    end
  end

  describe "crossposting on create" do

    before(:each) do
      @responder = Factory(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
      ALaMinuteAnswer.any_instance.stubs(:responder).returns(@responder)
    end

    it "should schedule a crosspost to Twitter" do
      twitter_client = mock
      @responder.stubs(:twitter_client).returns(twitter_client)
      twitter_client.expects(:send_at).returns(true)
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
    end

    it "should not crosspost to Twitter when no crosspost flag is set" do
      @responder.expects(:twitter_client).never
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_twitter_at => Time.now, :no_twitter_crosspost => "1"))
    end

    it "should schedule a crosspost to Facebook" do
      @responder.expects(:send_at).returns(true)
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
    end

    it "should not crosspost to Facebook when no crosspost flag is set" do
      @responder.expects(:send_at).never
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_facebook_at => Time.now, :no_fb_crosspost => "1"))
    end

  end

end