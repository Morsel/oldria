require_relative '../spec_helper'

describe SoloDiscussion do
  it { should belong_to(:trend_question) }
  it { should belong_to(:employment) } 
  it { should validate_uniqueness_of(:employment_id).scoped_to(:trend_question_id) }   

  describe ".with_replies" do
    it "should return with_replies" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      SoloDiscussion.with_replies.should == SoloDiscussion.find(:all,:conditions=>["comments_count>?",0])
    end
  end

  describe ".without_replies" do
    it "should return without_replies" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      SoloDiscussion.without_replies.should == SoloDiscussion.find(:all,:conditions=>["comments_count=?",0])
    end
  end

  describe "#message" do
    it "should return message" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.message.should == [solo_discussion.trend_question.subject, solo_discussion.trend_question.body].reject(&:blank?).join(": ")
    end
  end

  describe "#display_message" do
    it "should return display_message" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.display_message.should == solo_discussion.trend_question.display_message
    end
  end

  describe "#inbox_title" do
    it "should return inbox_title" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.inbox_title.should == solo_discussion.trend_question.class.title
    end
  end

  describe "#email_title" do
    it "should return email_title" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.email_title.should == solo_discussion.inbox_title
    end
  end

  describe "#email_body" do
    it "should return email_body" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.email_body.should == solo_discussion.message
    end
  end

  describe "#short_title" do
    it "should return short_title" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.short_title.should == "sd"
    end
  end

  describe "#scheduled_at" do
    it "should return scheduled_at" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.scheduled_at.should == solo_discussion.trend_question.scheduled_at
    end
  end

  describe "#soapbox_entry" do
    it "should return soapbox_entry" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.soapbox_entry.should == solo_discussion.trend_question.soapbox_entry
    end
  end

  describe "#employee" do
    it "should return employee" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.employee.should == solo_discussion.employment.try(:employee)
    end
  end

  describe "#recipients_can_reply?" do
    it "should return recipients_can_reply?" do
      solo_discussion = FactoryGirl.create(:solo_discussion)
      solo_discussion.recipients_can_reply?.should == true
    end
  end  


end
