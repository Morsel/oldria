# == Schema Information
#
# Table name: discussion_seats
#
#  id            :integer         not null, primary key
#  user_id       :integer         indexed
#  discussion_id :integer         indexed
#  created_at    :datetime
#  updated_at    :datetime
#

class DiscussionSeat < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
end
