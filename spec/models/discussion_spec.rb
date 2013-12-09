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

end
