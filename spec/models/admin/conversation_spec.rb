# == Schema Information
#
# Table name: admin_conversations
#
#  id               :integer         not null, primary key
#  recipient_id     :integer
#  admin_message_id :integer
#  comments_count   :integer         default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec/spec_helper'

describe Admin::Conversation do
  should_belong_to :admin_message
  should_belong_to :recipient, :class_name => 'User'

  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_conversation)
  end

  it "should create a new instance given valid attributes" do
    Admin::Conversation.any_instance.stubs(:notify_recipients).returns(true)
    Admin::Conversation.create!(@valid_attributes)
  end

  it "should send the conversation recipients a email notification when created" do
    user = Factory(:user, :prefers_receive_email_notifications => true)
    message = Factory(:qotd, :scheduled_at => Time.now)
    admin_conversation = Admin::Conversation.new(Factory.attributes_for(:admin_conversation, :recipient => user, :admin_message => message))
    admin_conversation.expects(:send_at).with(message.scheduled_at, :queued_message_sending)
    admin_conversation.save!
  end

end
