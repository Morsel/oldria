require_relative '../spec_helper'

describe Discussion do
  should_have_many :discussion_seats, :dependent => :destroy
  should_have_many :users, :through => :discussion_seats
  should_have_many :attachments
  should_belong_to :poster, :class_name => 'User'
  should_validate_presence_of :title

  should_accept_nested_attributes_for :comments, :attachments

  before(:each) do
    @valid_attributes = Factory.attributes_for(:discussion)
  end

  it "should create a new instance given valid attributes" do
    Discussion.create!(@valid_attributes)
  end

  it "should have unique users (no repeats)" do
    DiscussionSeat.destroy_all
    user = Factory(:user)
    discussion = Discussion.create(@valid_attributes.merge(:user_ids => [user.id, user.id]))
    discussion.users.should == [user]
    DiscussionSeat.count.should == 1
  end

  it "should send notifications to the invited users" do
    user = Factory(:user)
    discussion = Discussion.new(@valid_attributes)
    discussion.poster = Factory(:user)
    discussion.expects(:notify_recipients)
    discussion.save
  end

end
