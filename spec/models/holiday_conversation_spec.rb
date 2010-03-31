# == Schema Information
# Schema version: 20100331215807
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

require 'spec/spec_helper'

describe HolidayConversation do
  should_belong_to :holiday
  should_belong_to :recipient
  should_have_scope :with_replies, :conditions => 'comments_count > 0'
  should_have_scope :without_replies, :conditions => 'comments_count = 0'
end
