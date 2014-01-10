# == Schema Information
#
# Table name: holidays
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  date                 :date
#  created_at           :datetime
#  updated_at           :datetime
#  employment_search_id :integer
#

class Holiday < ActiveRecord::Base
  belongs_to :employment_search
  has_many :holiday_discussions, :dependent => :destroy
  has_many :restaurants, :through => :holiday_discussions

  has_many :admin_holiday_reminders, :class_name => 'Admin::HolidayReminder', :dependent => :destroy
  accepts_nested_attributes_for :admin_holiday_reminders

  validates_presence_of :name
  validates_presence_of :date

  before_save :update_restaurants_from_search_criteria

  def update_restaurants_from_search_criteria
    self.restaurant_ids = employment_search.restaurant_ids
  end

  def accepted_holiday_discussions
    #holiday_discussions.accepted
    holiday_discussions.map(&:accepted)
  end

  def accepted_holiday_discussion_restaurant_ids
    accepted_holiday_discussions.map(&:restaurant_id)
  end

  def future_reminders
    admin_holiday_reminders.all(:conditions => ['scheduled_at > ?', Time.now])
  end

  def remove_recipient_from_future_reminders(recipient)
    future_reminders.each do |reminder|
      reminder.recipient_ids = reminder.recipient_ids.to_a - [recipient.id]
      reminder.save
    end
  end

  def reminders_count
    admin_holiday_reminders.size
  end

  def reply_count
    holiday_discussions.with_replies.count
  end

  def viewable_by?(employment)
    return false unless employment && employment_search
    employment.employee == employment.restaurant.try(:manager) ||
    employment.omniscient? ||
    employment_search.employments.include?(employment)
  end

  def next_reminder
    admin_holiday_reminders.first(:order => 'scheduled_at ASC')
  end

end
