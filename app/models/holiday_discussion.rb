# == Schema Information
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

class HolidayDiscussion < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :holiday
  has_many :holiday_discussion_reminders, :dependent => :destroy
  has_many :holiday_reminders, :through => :holiday_discussion_reminders

  acts_as_commentable
  acts_as_readable

  validates_uniqueness_of :restaurant_id, :scope => :holiday_id

  scope :with_replies, :conditions => 'comments_count > 0'
  scope :without_replies, :conditions => 'comments_count = 0'
  scope :needs_reply, :conditions => { :accepted => false }
  
  scope :for_restaurants, lambda { |restaurants|
    { :conditions => { :restaurant_id => restaurants.map(&:id) } }
  }
  
  scope :open, { :conditions => { :accepted => false } }
  scope :closed, { :conditions => { :accepted => true } }

  attr_accessible :restaurant_id,:holiday_id,:comments_count,:accepted

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


