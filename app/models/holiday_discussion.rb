# == Schema Information
# Schema version: 20100415205144
#
# Table name: holiday_discussions
#
#  id             :integer         not null, primary key
#  restaurant_id  :integer
#  holiday_id     :integer
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  accepted       :boolean
#

class HolidayDiscussion < ActiveRecord::Base

  acts_as_readable

  belongs_to :restaurant
  belongs_to :holiday
  has_many :holiday_discussion_reminders
  has_many :holiday_reminders, :through => :holiday_discussion_reminders

  acts_as_commentable

  validates_uniqueness_of :restaurant_id, :scope => :holiday_id

  named_scope :with_replies, :conditions => 'comments_count > 0'
  named_scope :without_replies, :conditions => 'comments_count = 0'
  named_scope :needs_reply, :conditions => { :accepted => false }

  def inbox_title
    holiday.try(:name)
  end

end
