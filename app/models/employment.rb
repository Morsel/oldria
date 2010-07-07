# == Schema Information
#
# Table name: employments
#
#  id                 :integer         not null, primary key
#  employee_id        :integer
#  restaurant_id      :integer
#  created_at         :datetime
#  updated_at         :datetime
#  restaurant_role_id :integer
#  omniscient         :boolean
#

class Employment < ActiveRecord::Base
  belongs_to :employee, :class_name => "User"
  belongs_to :restaurant
  belongs_to :restaurant_role
  has_many :responsibilities
  has_many :subject_matters, :through => :responsibilities
  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'recipient_id'
  has_many :admin_discussions, :through => :restaurant
  has_many :admin_messages, :through => :admin_conversations, :class_name => 'Admin::Message'
  has_many :holiday_conversations, :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :holidays, :through => :holiday_conversations

  accepts_nested_attributes_for :employee

  validates_presence_of :employee_id
  validates_presence_of :restaurant_id
  validates_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"

  named_scope :restaurants_metro_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :metropolitan_area_id => ids.map(&:to_i)}}}
  }

  named_scope :restaurants_cuisine_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :cuisine_id => ids.map(&:to_i)}}}
  }

  named_scope :restaurants_region_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :james_beard_region_id => ids.map(&:to_i)}}}
  }

  named_scope :unique_users, :group => :employee_id

  named_scope :by_restaurant_name, :order => 'restaurants.name ASC, users.last_name ASC', :include => [:restaurant, :employee]
  named_scope :by_employee_last_name, :order => 'users.last_name ASC', :include => :employee

  def employee_name
    @employee_name ||= employee && employee.name
  end

  def employee_email
    @employee_email ||= employee && employee.email
  end

  def employee_email=(email)
    self.employee = User.find_by_email(email)
  end

  def restaurant_name
    @restaurant_name ||= restaurant && restaurant.name
  end

  def name_and_restaurant
    "#{employee_name} (#{restaurant_name})"
  end

  def viewable_media_requests
    restaurant.media_requests.select {|mr| mr.viewable_by? self }
  end

end
