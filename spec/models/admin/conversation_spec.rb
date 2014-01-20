require_relative '../../spec_helper'

describe Admin::Conversation do
  it { should belong_to :admin_message }
  it { should belong_to(:recipient).class_name('User') }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:admin_conversation)
  end

  it "should create a new instance given valid attributes" do
    Admin::Conversation.any_instance.stubs(:notify_recipients).returns(true)
    Admin::Conversation.create!(@valid_attributes)
  end

  it "should send the conversation recipients a email notification when created" do
    user = FactoryGirl.create(:user, :prefers_receive_email_notifications => true)
    message = FactoryGirl.create(:qotd, :scheduled_at => Time.now)
    admin_conversation = Admin::Conversation.new(FactoryGirl.attributes_for(:admin_conversation, :recipient => user, :admin_message => message))
    admin_conversation.queued_message_sending
    admin_conversation.save!
  end

  describe ".with_replies" do
    it "should return with_replies" do
      solo_media_discussion = FactoryGirl.create(:admin_conversation)
      Admin::Conversation.with_replies.should == Admin::Conversation.find(:all,:conditions=>["comments_count>?",0])
    end
  end

  describe ".without_replies" do
    it "should return without_replies" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      Admin::Conversation.without_replies.should == Admin::Conversation.find(:all,:conditions=>["comments_count = ?",0])
    end
  end

  describe "#inbox_title" do
    it "should return inbox_title" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.inbox_title.should == admin_conversation.admin_message.inbox_title
    end
  end

  describe "#email_title" do
    it "should return email_title" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.email_title.should == admin_conversation.inbox_title
    end
  end
  
  describe "#short_title" do
    it "should return short_title" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.short_title.should == "qotd"
    end
  end   

  describe "#email_body" do
    it "should return email_body" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.email_body.should == admin_conversation.admin_message.message
    end
  end   

  describe "#message" do
    it "should return message" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.message.should == admin_conversation.admin_message.message
    end
  end   

  describe "#display_message" do
    it "should return display_message" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.display_message.should == admin_conversation.admin_message.display_message
    end
  end   

  describe "#scheduled_at" do
    it "should return scheduled_at" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.scheduled_at.should == admin_conversation.admin_message.scheduled_at
    end
  end   

  describe "#recipients_can_reply?" do
    it "should return recipients_can_reply?" do
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.recipients_can_reply?.should == true
    end
  end   

  describe "#create_response_for_user" do
    it "should return create_response_for_user" do
      user = FactoryGirl.create(:user)
      comment = FactoryGirl.create(:comment)
      admin_conversation = FactoryGirl.create(:admin_conversation)
      admin_conversation.comments.create(:user => user, :comment => comment)
    end
  end   


end
