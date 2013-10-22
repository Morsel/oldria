# == Schema Information
#
# Table name: events
#
#  id            :integer         not null, primary key
#  restaurant_id :integer
#  title         :string(255)
#  start_at      :datetime
#  end_at        :datetime
#  location      :string(255)
#  description   :text
#  category      :string(255)
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  parent_id     :integer
#

class Event < ActiveRecord::Base
  
  CATEGORIES = ['Charity', 'Holiday', 'Private', 'Promotion', 'Other']
  ADMIN_CATEGORIES = [['Charity', 'admin_charity'], ['Holiday', 'admin_holiday']]
  STATUSES = ['Pending', 'Booked']
  
  belongs_to :restaurant
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :attachments

  validates_presence_of :title, :start_at, :end_at, :category
  validates_presence_of :location, :unless => Proc.new { |event| ["admin_holiday", "admin_charity"].include? event.category }
  validates_presence_of :status, :if => Proc.new { |event| event.category == "Private" }
  
  validate :end_comes_after_start
  
  scope :for_month_of, lambda { |date| 
    { :conditions => { :start_at => date.beginning_of_month.at_midnight..date.end_of_month.end_of_day } } 
  }
  
  scope :for_location, lambda { |location|
    { :conditions => { :location => location } }
  }
  
  scope :by_category, lambda { |category|
    { :conditions => { :category => category } }
  }
  
  scope :from_ria, :conditions => { :category => ['admin_charity', 'admin_holiday'] }
  
  scope :children, lambda { |event| 
    { :conditions => { :parent_id => event.id } }
  }
  
  scope :admin_locations, :conditions => { :category => ["admin_charity", "admin_holiday"] }, :select => "distinct location"
  
  def date
    start_at
  end
  
  def calendar
    if ADMIN_CATEGORIES.flatten.include? self.category
      case self.category
      when "admin_charity"
        "Charity"
      when "admin_holiday"
        "Holiday"
      end
    else
      self.category
    end
  end
  
  def children
    unless self.restaurant_id
      Event.children(self)
    end
  end
  
  def child_count
    unless self.restaurant_id
      Event.count(:conditions => { :parent_id => self.id })
    end
  end
  
  def parent
    Event.find(self.parent_id) if self.parent_id
  end
  
  def private?
    self.category == "Private"
  end
  
  def accepted_for_restaurant?(restaurant)
    child_count > 0 && !Event.children(self).find(:first, :restaurant_id == restaurant.id).nil?
  end
  
  def self.ria_locations
    self.admin_locations.map { |l| "Location: #{l.location}"}.sort
  end
  
  protected
  
  def end_comes_after_start
    if start_at && end_at && end_at < start_at
      errors.add(:end_at, "The end time must be after the start time")
    end
  end
  
end
