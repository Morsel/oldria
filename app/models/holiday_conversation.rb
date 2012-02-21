# == Schema Information
# Schema version: 20120217190417
#
# Table name: holiday_conversations
#
#  id             :integer         not null, primary key
#  recipient_id   :integer
#  holiday_id     :integer
#  comments_count :integer         default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  accepted       :boolean
#
# Indexes
#
#  index_holiday_conversations_on_holiday_id    (holiday_id)
#  index_holiday_conversations_on_recipient_id  (recipient_id)
#

class HolidayConversation < ActiveRecord::Base
  belongs_to :holiday
  belongs_to :recipient, :class_name => "Employment"
  acts_as_commentable
  acts_as_readable

  named_scope :with_replies, :conditions => 'comments_count > 0'
  named_scope :without_replies, :conditions => 'comments_count = 0'

end
