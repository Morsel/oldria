class HolidayDiscussion < ActiveRecord::Base
  
  belongs_to :restaurant
  belongs_to :holiday
  has_many :holiday_discussion_reminders
  has_many :holiday_reminders, :through => :holiday_discussion_reminders
  
  acts_as_commentable

  validates_uniqueness_of :restaurant_id, :scope => :holiday_id
  
  named_scope :with_replies, :conditions => 'comments_count > 0'
  named_scope :without_replies, :conditions => 'comments_count = 0'
  
end
