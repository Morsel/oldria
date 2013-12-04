require_relative '../spec_helper'

describe QuickReply do
  it "should not be valid only without a message" do
    quick_reply = QuickReply.new
    quick_reply.should_not be_valid
  end
  
  it "should be valid with a message" do
    quick_reply = QuickReply.new
    quick_reply.message = Factory(:trend_question)
    quick_reply.user = Factory(:user)
    quick_reply.reply_text = "Well, hello!"
    quick_reply.restaurant_ids = ["1"]
    quick_reply.should be_valid
  end
end
