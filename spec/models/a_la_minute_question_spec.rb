require_relative '../spec_helper'

describe ALaMinuteQuestion do
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:question) { FactoryGirl.create(:a_la_minute_question) }
  it { should have_many(:trace_keywords) }  
  it { should have_many(:a_la_minute_answers).dependent(:destroy) }
  it { should validate_presence_of(:question) }  
  it { should ensure_inclusion_of(:kind).in_array(%w(restaurant user)) }

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

  describe "#answers_for" do
    it "should return answers_for" do
      question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
      restaurant = FactoryGirl.create(:restaurant)
      answer1 = FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
      answer2 = FactoryGirl.create(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question)
      question.answers_for(restaurant).should == ALaMinuteAnswer.all
    end
  end

  describe "#latest_answer" do
    it "should return latest_answer" do
      question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
      question.latest_answer.should == question.a_la_minute_answers.from_premium_responders.first
    end
  end

  describe ".current_inspiration" do
    it "should return current_inspiration" do
      question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
      ALaMinuteQuestion.current_inspiration.should == ALaMinuteQuestion.first(:conditions => "question LIKE 'Our current inspiration%'")
    end
  end

  describe ".most_recent_for_soapbox" do
    it "should return current_inspiration" do
      question = FactoryGirl.create(:a_la_minute_question, :kind => 'restaurant')
      a_la_minute_question = ALaMinuteQuestion.all(:joins => 'LEFT OUTER JOIN a_la_minute_answers
                   ON `a_la_minute_answers`.a_la_minute_question_id = `a_la_minute_questions`.id
                   INNER JOIN subscriptions
                   ON `subscriptions`.subscriber_id = `a_la_minute_answers`.responder_id
                   AND `subscriptions`.subscriber_type = `a_la_minute_answers`.responder_type',
        :order => "a_la_minute_answers.created_at DESC",
        :conditions => ["subscriptions.id IS NOT NULL
                         AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
                         Date.today])#.uniq[0...count]
      ALaMinuteQuestion.most_recent_for_soapbox(count = 10).should == a_la_minute_question
    end
  end

end

