class HolidayDiscussion < ActiveRecord::Base
  
  belongs_to :restaurant
  belongs_to :holiday
  has_and_belongs_to_many :holiday_reminders, :class_name => "Admin::HolidayReminder"
  
  acts_as_commentable
  acts_as_readable

  validates_uniqueness_of :restaurant_id, :scope => :holiday_id
  
  named_scope :with_replies, :conditions => 'comments_count > 0'
  named_scope :without_replies, :conditions => 'comments_count = 0'
  
  def self.accepted
    []
  end

  def accepted?
    false
  end
  
end
