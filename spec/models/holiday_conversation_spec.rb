require_relative '../spec_helper'

describe HolidayConversation do
  should_belong_to :holiday
  should_belong_to :recipient
  should_have_scope :with_replies, :conditions => 'comments_count > 0'
  should_have_scope :without_replies, :conditions => 'comments_count = 0'
end
