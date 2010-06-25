require 'spec/spec_helper'

describe QuickReply do
  it "should not be valid only without a message" do
    quick_reply = QuickReply.new
    quick_reply.should_not be_valid
  end
  
  it "should be valid with a message" do
    quick_reply = QuickReply.new
    quick_reply.message = Factory(:trend_question)
  end
end
