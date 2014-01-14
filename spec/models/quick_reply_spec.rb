require_relative '../spec_helper'

describe QuickReply do
  it { should validate_presence_of(:reply_text) }
  it { should validate_presence_of(:message_id) }
  it { should validate_presence_of(:message_type) }    
  it { should validate_presence_of(:user_id) }    
  it { should ensure_length_of(:reply_text).is_at_most(2000) }
  it { should belong_to(:message) }
  it { should belong_to(:user) }
  
  it "should not be valid only without a message" do
    quick_reply = QuickReply.new
    quick_reply.should_not be_valid
  end
  
  it "should be valid with a message" do
    quick_reply = QuickReply.new
    quick_reply.message = FactoryGirl.create(:trend_question)
    quick_reply.user = FactoryGirl.create(:user)
    quick_reply.reply_text = "Well, hello!"
    quick_reply.restaurant_ids = ["1"]
    quick_reply.should be_valid
  end
end
