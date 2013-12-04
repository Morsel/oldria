require_relative '../../spec_helper'

describe Admin::Message do
  should_have_many :admin_conversations
  should_have_many :recipients, :through => :admin_conversations
  should_validate_presence_of :message

  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_message)
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
    qotd = Factory(:qotd)
    conversation = Factory(:admin_conversation, :admin_message => qotd)
    conversation.comments.create(Factory.attributes_for(:comment))
    qotd.reply_count.should == 1
  end
  
end


