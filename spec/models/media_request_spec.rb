require 'spec/spec_helper'

describe MediaRequest do
  should_belong_to :sender, :class_name => 'User'
  should_belong_to :media_request_type
  should_have_many :media_request_conversations
  should_have_many :conversations_with_comments
  should_have_many :recipients, :through => :media_request_conversations
  should_have_many :attachments, :as => :attachable, :class_name => '::Attachment'
  should_validate_presence_of :sender_id

  before(:each) do
    @employee = Factory(:user, :username => "employee", :email => "employee@example.com")
    @restaurant = Factory(:restaurant)
    @employment = Factory(:employment, :restaurant => @restaurant, :employee => @employee)
  end

  describe "senders and receivers" do
    it "should build conversations with other folks" do
      mr = Factory(:media_request, :sender => Factory(:user), :recipients => [@employment])
      mr.media_request_conversations.first.recipient.should == @employment
      @employee.media_request_conversations.first.media_request.should eql(mr)
    end

    describe "finding" do
      before do
        @media_request = Factory(:media_request,
                                  :sender => Factory(:user),
                                  :recipients => [@employment])
      end

      it "conversation by way of recipient should include the first conversation" do
        @media_request.conversation_with_recipient(@employment).should be_a(MediaRequestConversation)
      end

      it "restaurants" do
        @media_request.restaurants.should == [@restaurant]
      end
    end
  end

  describe "fields" do
    before(:each) do
      @request = Factory.build(:media_request)
      @request.stubs(:recipient_ids).returns([1])
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
    before(:each) do
      @request = Factory.build(:media_request)
    end

    it "should start out as a draft" do
      @request.should be_draft
    end

    it "should transition to pending after fields are filled in" do
      @request.fill_out!
      @request.should be_pending
    end

    it "should assign recipients before saving the first time" do
      # it goes to everyone when @subject_matters is nil
      @request.restaurant_ids = [@restaurant.id]
      @request.save
      @request.reload
      @request.recipients.should include(@employment)
    end

    it "should assign recipients before saving with subject matters" do
      @subject_matter = Factory(:subject_matter, :name => "Blah")
      @employment.subject_matters << @subject_matter
      @request.restaurant_ids = [@restaurant.id]
      @request.subject_matter_ids = [@subject_matter.id]
      @request.save
      @request.recipients.should include(@employment)
    end

    it "should be approvable" do
      UserMailer.stubs(:deliver_media_request_notification).returns(true)
      media_request = Factory(:pending_media_request)
      media_request.approve
      media_request.save
      media_request.should_not be_pending
      media_request.should be_approved
    end

    describe "when approved email" do
      it "should be sent to each recipient" do
        @request = Factory.build(:media_request, :status => 'pending')
        @receiver = Factory(:user, :name => "Hambone Fisher", :email => "hammy@spammy.com")
        @request.sender = Factory(:media_user, :username => "jim", :email => "media@media.com")
        @request.recipients = [@employment]
        UserMailer.expects(:deliver_media_request_notification)
        @request.approve!.should == true
        Delayed::Job.last.invoke_job if defined?(Delayed::Job)
      end
    end
  end

  describe "brand new request" do
    before do
      @subject_matter = Factory(:subject_matter, :name => "Ham")
      @employment2 = Factory(:assigned_employment, :subject_matters => [@subject_matter])
      sender = Factory(:media_user)
      @request = Factory.build(:media_request, :sender => sender, :recipients => [])
    end

    it "should be invalid when no restaurants are found" do
      @request.restaurant_ids = []
      @request.should_not be_valid
      @request.save.should be_false
    end

    it "should be valid with recipients" do
      @request.recipient_ids = [@employment2.id]
      @request.should be_valid
    end

    it "should be valid when restaurants are found" do
      @request.restaurant_ids = [@employment2.restaurant.id.to_s]
      @request.subject_matter_ids = [@subject_matter.id.to_s]
      @request.should be_valid
      @request.save.should be_true
    end

    it "should be invalid when not recipients are chosen" do
      @request.recipient_ids = []
      @request.should_not be_valid
    end
  end

end
