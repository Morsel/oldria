class Employment < ActiveRecord::Base
  belongs_to :employee, :class_name => "User"
  belongs_to :restaurant
  belongs_to :restaurant_role
  has_many :responsibilities
  has_many :subject_matters, :through => :responsibilities
  has_many :media_request_conversations, :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :media_requests, :through => :media_request_conversations

  accepts_nested_attributes_for :employee

  validates_presence_of :employee_id
  validates_presence_of :restaurant_id
  validates_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"

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
end
