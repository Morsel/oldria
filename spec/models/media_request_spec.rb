require File.dirname(__FILE__) + '/../spec_helper'

describe MediaRequest do
  describe "senders and receivers" do
    before(:each) do
      @receiver = Factory(:user, :id => 78)
    end

    it "should require a sender" do
      MediaRequest.new.should_not be_valid
      MediaRequest.new(:sender_id => 1).should be_valid
    end
  
    it "should have many conversations" do
      mrc = Factory(:media_request_conversation)
      MediaRequest.first.media_request_conversations.should include(mrc)
    end
  
    it "should build conversations with other folks" do
      mr = Factory(:media_request, :sender => Factory(:user))
      mr.media_request_conversations.build(:recipient_id => 78)
      mr.save
      mr.media_request_conversations.first.recipient.should == @receiver
      @receiver.received_media_requests.should include(mr)
    end

    describe "finding conversation by way of recipient" do
      it "should include the first conversation" do
        media_request = Factory(:media_request, :sender => Factory(:user), :recipients => [@receiver])
        media_request.conversation_with_recipient(@receiver).should be_a(MediaRequestConversation)
      end
    end
  end
  
  describe "fields" do
    before(:each) do
      @request = Factory.build(:media_request)
    end

    it "should be empty Hash for new instance" do
      @request.fields.should == {}
    end

    it "should be a hash with keys and values" do
      @request.fields = {:hello => "No!"}
      @request.fields.should be_a(Hash)
      @request.save
      MediaRequest.find(@request.id).fields.should be_a(Hash)
    end
    
    it "should raise an error for an array" do
      @request.fields = ['hello', 'sammy']
      lambda{ @request.save }.should raise_error(ActiveRecord::SerializationTypeMismatch)
    end
    
    it "should reject blank values" do
      @request.fields = {:hello => '', :nothing => "Booya!"}
      @request.fields[:hello].should be_nil
    end
  end
  
  describe "message_with_fields" do
    before(:each) do
      @request = Factory.build(:media_request)
    end
    
    it "should join a field and the message" do
      @request.message = "This is a message"
      @request.fields = {:date => "December 10"}
      @request.message_with_fields.should == <<-EOT.gsub(/^[ ]+/,'').chomp
      Date: December 10
      
      This is a message
      EOT
    end
    
    it "should join all fields and the message" do
      @request.message = "Messages are neat"
      @request.fields = {:photo_requirements => "8x10 large", :time_of_event => "10am"}
      @request.message_with_fields.should include("Photo requirements: 8x10 large")
      @request.message_with_fields.should include("Time of event: 10am")
      @request.message_with_fields.should include("Messages are neat")
    end
  end
  
  describe "status" do
    it "should start out pending" do
      MediaRequest.new.should be_pending
    end
    
    it "should be approvable" do
      media_request = MediaRequest.new(:message => 'Message')
      media_request.save
      media_request.approve!
      media_request.should_not be_pending
      media_request.should be_approved
    end
  end

end
