# == Schema Information
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

class HolidayConversation < ActiveRecord::Base
  belongs_to :holiday
  belongs_to :recipient, :class_name => "Employment"
  acts_as_commentable
  acts_as_readable

  scope :with_replies, :conditions => 'comments_count > 0'
  scope :without_replies, :conditions => 'comments_count = 0'

end
