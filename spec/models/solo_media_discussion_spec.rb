require_relative '../spec_helper'

describe SoloMediaDiscussion do
  it { should belong_to(:media_request) }
  it { should belong_to(:employment) }

  before(:each) do
    @valid_attributes = {
      :media_request_id => 1,
      :employment_id => 1,
      :comments_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    SoloMediaDiscussion.create!(@valid_attributes)
  end

  describe ".with_comments" do
    it "should return with_comments" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      SoloMediaDiscussion.with_comments.should == SoloMediaDiscussion.find(:all,:conditions=>["comments_count>?",0])
    end
  end

  describe ".order" do
    it "should return order" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      SoloMediaDiscussion.order.should == SoloMediaDiscussion.all(order: 'created_at ASC')
    end
  end

  describe "#employee" do
    it "should return employee" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.employee.should == solo_media_discussion.employment.try(:employee)
    end
  end

  describe "#users" do
    it "should return users" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.users.should == [solo_media_discussion.employee, solo_media_discussion.media_request.sender]
    end
  end

  describe "#publication_string" do
    it "should return publication_string" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.publication_string.should == solo_media_discussion.media_request.publication_string
    end
  end

  describe "#email_title" do
    it "should return email_title" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.email_title.should == "Media Request"
    end
  end

  describe "#message" do
    it "should return message" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.message.should == "#{solo_media_discussion.publication_string} has a question for #{solo_media_discussion.recipient_name}"
    end
  end

  describe "#recipient_name" do
    it "should return recipient_name" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      solo_media_discussion.recipient_name.should == solo_media_discussion.employee.try(:name)
    end
  end


end

