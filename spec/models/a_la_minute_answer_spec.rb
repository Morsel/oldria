require_relative '../spec_helper'
describe ALaMinuteAnswer do
  it { should have_many(:trace_keywords) }
  it { should have_many(:soapbox_trace_keywords) }  
  it { should belong_to(:a_la_minute_question) }
  it { should belong_to(:responder) }
  it { should have_many(:twitter_posts).dependent(:destroy) }
  it { should have_many(:facebook_posts).dependent(:destroy) }
  it { should accept_nested_attributes_for(:twitter_posts).limit(3).allow_destroy(true) }
  it { should accept_nested_attributes_for(:facebook_posts).limit(3).allow_destroy(true) }
  it { should validate_presence_of(:a_la_minute_question_id) }
  it { should have_attached_file(:photo) }
  it { should validate_attachment_content_type(:attachment).allowing("application/pdf", "application/x-pdf") }
  it { should validate_attachment_content_type(:photo).allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png") }

  before(:each) do
    @question = FactoryGirl.create(:a_la_minute_question)
    @responder = FactoryGirl.create(:restaurant)
    @valid_attributes = {
      :answer => "value for answer",
      :a_la_minute_question => @question,
      :responder => @restaurant
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
        responder_1 = FactoryGirl.create(:restaurant)
        responder_2 = FactoryGirl.create(:restaurant)

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
      q1 = FactoryGirl.create(:a_la_minute_question)
      q2 = FactoryGirl.create(:a_la_minute_question)
      q3 = FactoryGirl.create(:a_la_minute_question)
      q4 = FactoryGirl.create(:a_la_minute_question)
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
      q1 = FactoryGirl.create(:a_la_minute_question)
      ans_1 = FactoryGirl.create(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 1.day.ago)
      ans_2 = FactoryGirl.create(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 3.day.ago)
      ans_3 = FactoryGirl.create(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 2.day.ago)
      ans_4 = FactoryGirl.create(:a_la_minute_answer, :a_la_minute_question => q1, :created_at => 1.hour.ago)
      ALaMinuteAnswer.archived_for(q1).should == [ans_1, ans_3, ans_2]
    end
  end

  describe "crossposting on create" do

    before(:each) do
      @responder = FactoryGirl.create(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
      ALaMinuteAnswer.any_instance.stubs(:responder).returns(@responder)
    end

    # it "should schedule a cross post to Twitter" do
    #   twitter_client = mock
    #   @responder.stubs(:twitter_client).returns(twitter_client)
    #   debugger
    #   twitter_client.expects(:send_at).returns(true)
    #   # (twitter_client.send_at).should be_true 
    #   ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
    # end

    it "should not crosspost to Twitter when no crosspost flag is set" do
      @responder.expects(:twitter_client).never
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_twitter_at => Time.now))
    end

    # it "should schedule a crosspost to Facebook" do
    #   @responder.expects(:send_at).returns(true)
    #   ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
    # end

    it "should not crosspost to Facebook when no crosspost flag is set" do
      @responder.expects(:send_at).never
      ALaMinuteAnswer.create(@valid_attributes.merge(:post_to_facebook_at => Time.now))
    end
  end

  describe "#content_type" do
    it "should return valid content_type" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      if (!(["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"].include?(a_la_minute_answer.photo_content_type)) && a_la_minute_answer.photo_file_name.present?)      
        value = errors.add(:photo, "Please upload a image type: jpeg, gif, or png") 
      end
      if !(["application/pdf", "application/x-pdf"].include?(a_la_minute_answer.attachment_content_type)) && a_la_minute_answer.attachment_file_name.present?
        value = errors.add(:attachment, "Please upload a valid pdf ") 
      end
      a_la_minute_answer.content_type.should ==  value
    end
  end

  describe "#question" do
    it "should return valid question" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      a_la_minute_answer.question.should ==  a_la_minute_answer.a_la_minute_question.question
    end
  end

  describe "#activity_name" do
    it "should return valid activity_name" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      a_la_minute_answer.activity_name.should ==  "A la Minute answer to #{a_la_minute_answer.question}"
    end
  end

  describe "#restaurant" do
    it "should return valid restaurant" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      a_la_minute_answer.restaurant.should ==  a_la_minute_answer.responder
    end
  end

  describe "#facebook_message" do
    it "should return valid facebook_message" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      a_la_minute_answer.facebook_message.should ==  a_la_minute_answer.answer
    end
  end

  describe "#post_to_twitter" do
    it "should return valid post_to_twitter" do
      a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
      message = "this is testing this is testing this is testing this is testing this is testing this is testing this is testing"
      message = message.blank? ? a_la_minute_answer.answer : message
      message = "#{message[0..(135-a_la_minute_answer.bitly_link.length)]} #{a_la_minute_answer.bitly_link}"
    end
  end
 

end