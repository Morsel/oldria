# == Schema Information
# Schema version: 20100316193326
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec/spec_helper'

describe Comment do

  it "should clear read status of admin conversations when a new comment is added" do
    user1 = Factory(:user)
    user2 = Factory(:user)
    convo = Factory(:admin_conversation, :admin_message => Factory(:qotd))
    convo.read_by!(user2)
    convo.comments.create(:title => "A comment", :user_id => user1.id)
    convo.read_by?(user2).should be_false
  end
  
end