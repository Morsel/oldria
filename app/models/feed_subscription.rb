# == Schema Information
# Schema version: 20120217190417
#
# Table name: feed_subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_feed_subscriptions_on_user_id  (user_id)
#  index_feed_subscriptions_on_feed_id  (feed_id)
#

class FeedSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates_presence_of :user_id, :feed_id
  validates_uniqueness_of :user_id, :scope => :feed_id
end
