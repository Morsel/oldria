class Event < ActiveRecord::Base
  
  CATEGORIES = ['Charity', 'Holiday', 'Private', 'Promotion', 'Other']
  ADMIN_CATEGORIES = [['Charity', 'admin_charity'], ['Holiday', 'admin_holiday']]
  STATUSES = ['Pending', 'Booked']
  
  belongs_to :restaurant
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :attachments

  validates_presence_of :title, :start_at, :end_at, :location, :category
  validates_presence_of :status, :if => Proc.new { |event| event.category == "Private" }
  
  validate :end_comes_after_start
  
  named_scope :for_month_of, lambda { |date| 
    { :conditions => { :start_at => date.beginning_of_month.at_midnight..date.end_of_month.end_of_day } } 
  }
  
  named_scope :by_category, lambda { |category|
    { :conditions => { :category => category } }
  }
  
  named_scope :from_ria, :conditions => { :category => ['admin_charity', 'admin_holiday'] }
  
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
  
  def child_count
    unless self.restaurant_id
      Event.count(:conditions => { :parent_id => self.id })
    end
  end
  
  def children
    unless self.restaurant_id
      Event.all(:conditions => { :parent_id => self.id })
    end
  end
  
  protected
  
  def end_comes_after_start
    if start_at && end_at && end_at < start_at
      errors.add(:end_at, "The end time must be after the start time")
    end
  end
  
end
