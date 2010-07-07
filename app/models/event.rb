class Event < ActiveRecord::Base
  
  CATEGORIES = ['Charity', 'Holiday', 'Private', 'Promotion', 'Other']
  ADMIN_CATEGORIES = [['Charity', 'admin_charity'], ['Holiday', 'admin_holiday']]
  STATUSES = ['Pending', 'Booked']
  
  belongs_to :restaurant
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :attachments

  validates_presence_of :title, :start_at, :end_at, :location, :category
  validates_presence_of :status, :if => Proc.new { |event| event.category == "Private" }
  
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
  
end
