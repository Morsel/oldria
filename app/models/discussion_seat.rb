# == Schema Information
# Schema version: 20120217190417
#
# Table name: discussion_seats
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  discussion_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_discussion_seats_on_user_id        (user_id)
#  index_discussion_seats_on_discussion_id  (discussion_id)
#

class DiscussionSeat < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
end
