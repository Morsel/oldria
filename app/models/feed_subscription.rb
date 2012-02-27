# == Schema Information
#
# Table name: feed_subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer         indexed
#  feed_id    :integer         indexed
#  created_at :datetime
#  updated_at :datetime
#

class FeedSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates_presence_of :user_id, :feed_id
  validates_uniqueness_of :user_id, :scope => :feed_id
end
