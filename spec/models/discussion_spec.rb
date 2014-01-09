require_relative '../spec_helper'

describe Discussion do
  it { should have_many(:discussion_seats).dependent(:destroy) } 
  it { should have_many(:users).through(:discussion_seats) }
  it { should have_many :attachments }
  it { should belong_to(:poster).class_name('User') }
  it { should validate_presence_of :title }

  it { should accept_nested_attributes_for :comments }
  it { should accept_nested_attributes_for :attachments }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:discussion)
  end

  it "should create a new instance given valid attributes" do
    Discussion.create!(@valid_attributes)
  end

  it "should have unique users (no repeats)" do
    DiscussionSeat.destroy_all
    user = FactoryGirl.create(:user)
    discussion = Discussion.create(@valid_attributes.merge(:user_ids => [user.id, user.id]))
    discussion.users.should == [user]
    DiscussionSeat.count.should == 1
  end

  it "should send notifications to the invited users" do
    user = FactoryGirl.create(:user)
    discussion = Discussion.new(@valid_attributes)
    discussion.poster = FactoryGirl.create(:user)
    discussion.expects(:notify_recipients)
    discussion.save
  end

  describe "#inbox_title" do
    it "should return the inbox title" do
      discussion = FactoryGirl.create(:discussion)
      discussion.inbox_title.should == "Discussion"
    end   
  end

  describe "#email_title" do
    it "should return the email title" do
      discussion = FactoryGirl.create(:discussion)
      discussion.email_title.should == discussion.inbox_title
    end   
  end

  describe "#message" do
    it "should return the message" do
      discussion = FactoryGirl.create(:discussion)
      discussion.message.should == discussion.title
    end   
  end

  describe "#action_required?" do
    it "should return the action_required?" do
      discussion = FactoryGirl.create(:discussion)
      user = FactoryGirl.build(:user)
      user.save(:validate => false)
      discussion.action_required?(user).should == discussion.comments_count > 0 && discussion.comments.last.user != user && !discussion.comments.last.read_by?(user)
    end   
  end

end
