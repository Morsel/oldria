require_relative '../spec_helper'

describe DirectMessage do
  it { should validate_presence_of :receiver }
  it { should validate_presence_of :sender }
  it { should validate_presence_of :body }
  it { should belong_to(:receiver).class_name('User').with_foreign_key('receiver_id') }
  it { should belong_to(:sender).class_name('User') }
  it { should have_many(:responses).with_foreign_key('in_reply_to_message_id').class_name('DirectMessage') }
  it { should belong_to(:parent).class_name('DirectMessage').with_foreign_key('in_reply_to_message_id') }
  it { DirectMessage.scoped.to_sql.should == DirectMessage.order("direct_messages.created_at DESC").to_sql }
  # it { should have_default_scope :order => 'direct_messages.created_at DESC' }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  before(:each) do
    @sender = FactoryGirl.create(:user, :username => 'sender')
    @getter = FactoryGirl.create(:user, :username => 'getter')
  end

  describe "associations"  do
    before(:each) do
      @dm = FactoryGirl.build(:direct_message, :sender => @sender, :receiver => @getter)
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
      dm = FactoryGirl.create(:direct_message, :sender => @sender, :receiver => @getter)
      @getter.direct_messages.first.should == dm
      @sender.sent_direct_messages.first.should == dm
    end
    # CIS there is no validation found in model that check sender and reciever are same
    # it "should be invalid if sender and receiver are the same" do
    #   dm = DirectMessage.new(:sender => @sender, :receiver => @sender, :body => "Blah")
    #   dm.should_not be_valid
    #   dm.should have(1).errors_on(:receiver)
    # end
  end

  describe "reply" do
    before(:each) do
      @original_message = FactoryGirl.create(:direct_message, :sender => @sender, :receiver => @getter)
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
      @admin = FactoryGirl.create(:admin)
      @message = FactoryGirl.create(:direct_message, :sender => @admin, :from_admin => true)
      normal_message = FactoryGirl.create(:direct_message)
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

  describe "#title" do
    it "should return title" do
      direct_message = FactoryGirl.create(:direct_message)
      DirectMessage.title.should == "Private Message"
    end
  end


  describe "#email_title" do
    it "should return email_title" do
      direct_message = FactoryGirl.create(:direct_message)
      direct_message.email_title.should ==  direct_message.class.title
    end
  end

  describe "#descendants" do
    it "should return descendants" do
      direct_message = FactoryGirl.create(:direct_message)
      direct_message.descendants.should ==  direct_message.responses.map {|child| child.descendants}.flatten + [direct_message]
    end
  end

  describe "#descendants_size" do
    it "should return descendants_size" do
      direct_message = FactoryGirl.create(:direct_message)
      direct_message.descendants_size.should ==  direct_message.descendants.size - 1
    end
  end

  describe "#from?" do
    it "should return from?" do
      direct_message = FactoryGirl.create(:direct_message)
      user = FactoryGirl.create(:user)
      direct_message.from?(user).should == false
    end
  end

end

