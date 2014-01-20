require_relative '../../spec_helper'

describe Admin::Message do
  it { should have_many(:admin_conversations).with_foreign_key('admin_message_id').class_name('Admin::Conversation').dependent(:destroy) }
  it { should have_many(:recipients).through(:admin_conversations) }
  it { should have_many(:attachments).class_name('Attachment').dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should validate_presence_of :message }
  it { should ensure_length_of(:slug).is_at_most(30) }
  
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:admin_message)
  end

  it "should create a new instance given valid attributes" do
    Admin::Message.create!(@valid_attributes)
  end

  it "should require class method ::title to be set in subclasses" do
    lambda{ Admin::Message.title }.should raise_error
  end

  it "should not be considered a broadcast message" do
    Admin::Message.new.should_not be_broadcast
  end

  it "should know how many replies it has received (through conversations)" do
    Admin::Message.new.reply_count.should == 0
    qotd = FactoryGirl.create(:qotd)
    conversation = FactoryGirl.create(:admin_conversation, :admin_message => qotd)
    conversation.comments.create(FactoryGirl.attributes_for(:comment))
    qotd.reply_count.should == 1
  end
  
  describe ".current" do
    it "should return current" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      Admin::Message.current.should == Admin::Message.find(:all,:conditions=>['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now])
    end
  end
  
  describe ".recent" do
    it "should return recent" do
      solo_media_discussion = FactoryGirl.create(:solo_media_discussion)
      Admin::Message.recent.should == Admin::Message.find(:all,:conditions=>['admin_messages.scheduled_at >= ?', 2.weeks.ago])
    end
  end

  describe "#broadcast" do
    it "should return broadcast" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.broadcast?.should == false
    end
  end  

  describe "#recipients_can_reply?" do
    it "should return recipients_can_reply" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.recipients_can_reply?.should == true
    end
  end  

  describe "#current?" do
    it "should return current" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.current?.should == admin_message.scheduled_at < Time.zone.now
    end
  end  

  describe "#reply_count" do
    it "should return reply_count" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.reply_count.should == admin_message.conversations_with_replies.count
    end
  end  

  describe "#comments" do
    it "should return comments" do
      admin_message = FactoryGirl.create(:admin_message)
      deep_includes = false
      includes = deep_includes ? :user : nil
      comment = Comment.scoped(:conditions => ["commentable_id IN (?) AND commentable_type = 'Admin::Conversation'",
      admin_message.admin_conversations.all(:select => "id").map { |d| d.id }],
      :include => includes, :group => "comments.id")
      admin_message.comments(deep_includes = false).should == comment
    end
  end  

  describe "#last_comment" do
    it "should return last_comment" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.last_comment.should == admin_message.comments.first(:order => "comments.created_at DESC", :limit => 1)
    end
  end 

  describe "#conversations_with_replies" do
    it "should return conversations_with_replies" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.conversations_with_replies.should == admin_message.admin_conversations.scoped.where('comments_count > 0', :include => :recipient)
    end
  end 

  describe "#conversations_without_replies" do
    it "should return conversations_without_replies" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.conversations_without_replies.should == admin_message.admin_conversations.scoped.where('comments_count < 1', :include => :recipient)
    end
  end 
  
  describe "#attachments_allowed?" do
    it "should return attachments_allowed?" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.attachments_allowed?.should == false
    end
  end 

  describe "#mailer_method" do
    it "should return mailer_method" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.mailer_method.should == 'message_notification'  
    end
  end 


end


