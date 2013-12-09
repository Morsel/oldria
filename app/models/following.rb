# == Schema Information
#
# Table name: followings
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  friend_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Following < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User'
  belongs_to :friend, :class_name => 'User'

  validates_uniqueness_of :friend_id,
                          :scope => [:follower_id],
                          :message => "You already follow that person"

  validate :you_cant_follow_yourself
	attr_accessible :friend, :follower,:follower_id,:friend_id   
  def you_cant_follow_yourself
    errors.add(:base, "You can't follow yourself") if follower == friend
  end
end
