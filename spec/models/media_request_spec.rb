require File.dirname(__FILE__) + '/../spec_helper'

describe MediaRequest do
  it "should require a sender" do
    MediaRequest.new.should_not be_valid
    MediaRequest.new(:sender_id => 1).should be_valid
  end
  
  it "should have many conversations" do
    mrc = Factory(:media_request_conversation)
    MediaRequest.first.media_request_conversations.should include(mrc)
  end
  
  it "should build conversations with other folks" do
    @receiver = Factory(:user, :id => 78)
    mr = Factory(:media_request, :sender => Factory(:user))
    mr.media_request_conversations.build(:recipient_id => 78)
    mr.save
    mr.media_request_conversations.first.recipient.should == @receiver
    @receiver.received_media_requests.should include(mr)
  end
end
