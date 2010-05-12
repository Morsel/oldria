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
  should_belong_to :recipient, :class_name => 'Employment'

  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_conversation)
  end

  it "should create a new instance given valid attributes" do
    Admin::Conversation.any_instance.stubs(:notify_recipients).returns(true)
    Admin::Conversation.create!(@valid_attributes)
  end

  it "should send the conversation recipients a email notification when created" do
    user = Factory(:user, :prefers_receive_email_notifications => true)
    employment = Factory(:employment, :employee => user)
    message = Factory(:qotd, :scheduled_at => Time.now)
    UserMailer.expects(:sent_at).with(message.scheduled_at, :deliver_message_notification, message, user)
    Admin::Conversation.create!(Factory.attributes_for(:admin_conversation, :recipient => employment, 
      :admin_message => message))
  end

end
