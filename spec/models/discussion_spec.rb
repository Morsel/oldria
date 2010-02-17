# == Schema Information
#
# Table name: discussions
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  body           :text
#  poster_id      :integer
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec/spec_helper'

describe Discussion do
  should_have_many :discussion_seats, :dependent => :destroy
  should_have_many :users, :through => :discussion_seats
  should_belong_to :poster, :class_name => 'User'
  should_validate_presence_of :title

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
    UserMailer.expects(:deliver_discussion_notification).with(discussion, user).returns(true)
    discussion.save
  end

end
