require_relative '../spec_helper'

describe HolidayConversation do
  it { should belong_to :holiday }
  it { should belong_to :recipient }
  it { HolidayConversation.with_replies.to_sql.should == "SELECT `holiday_conversations`.* FROM `holiday_conversations`  WHERE (comments_count > 0)"}
  it { HolidayConversation.without_replies.to_sql.should == "SELECT `holiday_conversations`.* FROM `holiday_conversations`  WHERE (comments_count = 0)" }
  # should_have_scope :with_replies, :conditions => 'comments_count > 0'
  # should_have_scope :without_replies, :conditions => 'comments_count = 0'
end
