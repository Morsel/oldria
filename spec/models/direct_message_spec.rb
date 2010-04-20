# == Schema Information
# Schema version: 20100331213108
#
# Table name: direct_messages
#
#  id                     :integer         not null, primary key
#  body                   :string(255)
#  sender_id              :integer         not null
#  receiver_id            :integer         not null
#  in_reply_to_message_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  from_admin             :boolean
#

require 'spec/spec_helper'

describe DirectMessage do
  should_validate_presence_of :receiver
  should_validate_presence_of :sender
  should_validate_presence_of :body
  should_have_default_scope :order => 'direct_messages.created_at DESC'

  before(:each) do
    @sender = Factory(:user, :username => 'sender')
    @getter = Factory(:user, :username => 'getter')
  end

  describe "associations"  do
    before(:each) do
      @dm = Factory.build(:direct_message, :sender => @sender, :receiver => @getter)
    end

    it "should be valid with sender and receiver" do
      @dm.should be_valid
    end

    it "should have a receiver" do
      @dm.receiver.should == @getter
    end

    it "should have a sender" do
      @dm.sender.should == @sender
    end

    it "should reciprocate the relationship" do
      dm = Factory.create(:direct_message, :sender => @sender, :receiver => @getter)
      @getter.direct_messages.first.should == dm
      @sender.sent_direct_messages.first.should == dm
    end

    it "should be invalid if sender and receiver are the same" do
      dm = DirectMessage.new(:sender => @sender, :receiver => @sender, :body => "Blah")
      dm.should_not be_valid
      dm.should have(1).errors_on(:receiver)
    end
  end

  describe "reply" do
    before(:each) do
      @original_message = Factory(:direct_message, :sender => @sender, :receiver => @getter)
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

  context "from admin" do
    before(:each) do
      @admin = Factory(:admin)
      @message = Factory(:direct_message, :sender => @admin, :from_admin => true)
      normal_message = Factory(:direct_message)
    end

    it "should know it's from an admin" do
      dm = DirectMessage.new(:sender => @admin, :receiver => @getter)
      dm.from_admin = true
      dm.should be_from_admin
    end

    it "should scope admin messages" do
      DirectMessage.all_from_admin.should == [@message]
    end
  end
end
