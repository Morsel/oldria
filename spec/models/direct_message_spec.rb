require File.dirname(__FILE__) + '/../spec_helper'

describe DirectMessage do
  before(:each) do
    @sender = Factory(:user, :username => 'sender')
    @getter = Factory(:user, :username => 'getter')
  end
  
  describe "associations"  do
    it "should be valid with sender and receiver" do
      dm = DirectMessage.new(:sender => @sender, :receiver => @getter)
      dm.should be_valid
    end

    it "should have a receiver" do
      dm = DirectMessage.new(:sender => @sender, :receiver => @getter)
      dm.receiver.should == @getter
    end

    it "should have a sender" do
      dm = DirectMessage.new(:sender => @sender, :receiver => @getter)
      dm.sender.should == @sender
    end

    it "should reciprocate the relationship" do
      dm = DirectMessage.create(:sender => @sender, :receiver => @getter)
      @getter.direct_messages.first.should == dm
      @sender.sent_direct_messages.first.should == dm
    end
  end
  
  describe "reply" do
    before(:each) do
      @original_message = DirectMessage.create!(:sender => @sender, :receiver => @getter)
    end
    it "should build a reply" do
      @original_message.build_reply.should be_a(DirectMessage)
      @original_message.build_reply.should be_new_record
    end

    it "should reverse the sender and receiver" do
      @original_message.build_reply.sender.should == @original_message.receiver
      @original_message.build_reply.receiver.should == @original_message.sender
    end
    
    it "should include the id of the original message" do
      reply = @original_message.build_reply
      reply.in_reply_to_message_id.should == @original_message.id
    end
    
    it "should know its parent (replied-to) message" do
      reply = @original_message.build_reply
      reply.parent_message.should == @original_message
    end
    
    it "should return nil if it has no parent" do
      @original_message.parent_message.should == nil
    end
  end
end
