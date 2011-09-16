# == Schema Information
# Schema version: 20110913204942
#
# Table name: discussion_seats
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  discussion_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class DiscussionSeat < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
end
