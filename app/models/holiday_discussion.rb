# == Schema Information
# Schema version: 20120217190417
#
# Table name: holiday_discussions
#
#  id             :integer         not null, primary key
#  restaurant_id  :integer
#  holiday_id     :integer
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  accepted       :boolean         default(FALSE)
#
# Indexes
#
#  index_holiday_discussions_on_holiday_id     (holiday_id)
#  index_holiday_discussions_on_restaurant_id  (restaurant_id)
#

class HolidayDiscussion < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :holiday
  has_many :holiday_discussion_reminders, :dependent => :destroy
  has_many :holiday_reminders, :through => :holiday_discussion_reminders

  acts_as_commentable
  acts_as_readable

  validates_uniqueness_of :restaurant_id, :scope => :holiday_id

  named_scope :with_replies, :conditions => 'comments_count > 0'
  named_scope :without_replies, :conditions => 'comments_count = 0'
  named_scope :needs_reply, :conditions => { :accepted => false }
  
  named_scope :for_restaurants, lambda { |restaurants|
    { :conditions => { :restaurant_id => restaurants.map(&:id) } }
  }
  
  named_scope :open, { :conditions => { :accepted => false } }
  named_scope :closed, { :conditions => { :accepted => true } }

  def inbox_title
    holiday.try(:name)
  end

  def email_title
    %Q[Discussion for "#{inbox_title}"]
  end

  def read_by?(user)
    accepted? || self.readings.map(&:user).include?(user)
  end

  def message
    holiday_reminders.first.message
  end

  def scheduled_at
    created_at
  end

  def employees
    restaurant.employees
  end

  def recipients_can_reply?
    true
  end
end


