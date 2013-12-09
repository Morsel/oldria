# == Schema Information
#
# Table name: employments
#
#  id                   :integer         not null, primary key
#  employee_id          :integer
#  restaurant_id        :integer
#  created_at           :datetime
#  updated_at           :datetime
#  restaurant_role_id   :integer
#  omniscient           :boolean
#  primary              :boolean         default(FALSE)
#  type                 :string(255)
#  public_profile       :boolean         default(TRUE)
#  position             :integer
#  solo_restaurant_name :string(255)
#

class Employment < ActiveRecord::Base
  acts_as_list :scope => :restaurant

  belongs_to :employee, :class_name => "User"
  belongs_to :restaurant
  belongs_to :restaurant_role

  has_many :responsibilities, :dependent => :destroy
  has_many :subject_matters, :through => :responsibilities
  
  # QOTDs
  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'recipient_id'
  
  # Trend questions and content requests
  has_many :admin_discussions, :through => :restaurant
  
  # Announcement and PR Tips
  has_many :admin_messages, :through => :admin_conversations, :class_name => 'Admin::Message'
  
  # Holidays
  has_many :holiday_conversations, :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :holidays, :through => :holiday_conversations

  accepts_nested_attributes_for :employee

  preference :receive_email_notifications, :default => true

  validates_presence_of :employee_id
  validates_presence_of :restaurant_id, :unless => Proc.new { |e| e.type == "DefaultEmployment" }

  validates_uniqueness_of :employee_id, :scope => :restaurant_id, :message => "is already associated with that restaurant"


  validates_presence_of :restaurant_role, :message => "Role is required field",:on => :update

  before_save :set_subject_matters_for_managers, :if => Proc.new { |e| e.omniscient }

  scope :restaurants_metro_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :metropolitan_area_id => ids.map(&:to_i)}}}
  }

  scope :restaurants_cuisine_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :cuisine_id => ids.map(&:to_i)}}}
  }

  scope :restaurants_region_id, lambda { |ids|
    {:joins => :restaurant, :conditions => {:restaurants => { :james_beard_region_id => ids.map(&:to_i)}}}
  }

  scope :handling_subject_matter_id, lambda { |subject_matter_id|
    {:joins => "LEFT OUTER JOIN responsibilities ON responsibilities.employment_id = employments.id",
      :conditions => ['responsibilities.subject_matter_id IN(?) OR omniscient = ?', subject_matter_id, true],
      :group => 'employments.id'}
  }

  scope :unique_users, :group => :employee_id

  scope :by_restaurant_name, :order => 'restaurants.name ASC, users.last_name ASC', :include => [:restaurant, :employee]
  scope :by_employee_last_name, :order => 'users.last_name ASC', :include => :employee
  scope :primary, :order => 'updated_at DESC', :limit => 1, :conditions => { :primary => true }

  scope :public_profile_only, :conditions => { :public_profile => true }
  scope :by_position, :order => "position ASC"

  attr_accessible :position, :prefers_receive_email_notifications, :public_profile, :restaurant_role_id, :subject_matter_ids,
  :employee_email, :employee_id, :omniscient, :edit_privilege, :employee_attributes,:solo_restaurant_name,:type,:restaurant_id

  def employee_name
    @employee_name ||= employee && employee.name
  end
  
  def employee_last_name
    @employee_last_name ||= employee && employee.last_name
  end

  def employee_email
    @employee_email ||= employee && employee.email
  end

  def employee_email=(email)
    self.employee = User.find_by_email(email)
  end

  def restaurant_name
    @restaurant_name ||= restaurant && restaurant.try(:name)
  end

  def name_and_restaurant
    "#{employee_name} (#{restaurant_name})"
  end

  def viewable_media_request_discussions
    restaurant.media_request_discussions.approved.select { |d| d.viewable_by?(self) }
  end

  def viewable_unread_media_request_discussions
    restaurant.media_request_discussions.approved.select { |d| d.viewable_by?(self) && !d.read_by?(self.employee) }
  end

  def viewable_admin_discussions
    omniscient? ? all_discussions : filter_only_viewable(all_discussions)
  end

  def current_viewable_admin_discussions
    viewable_admin_discussions.select { |discussion| Time.now >= discussion.scheduled_at }
  end
  
  # Trend questions only
  def viewable_trend_discussions
    omniscient? ? admin_discussions.for_trends : filter_only_viewable(admin_discussions.for_trends)
  end
  
  def current_viewable_trend_discussions
    viewable_trend_discussions.select { |discussion| Time.now >= discussion.scheduled_at  }
  end
  
  # Content requests only
  def viewable_request_discussions
    omniscient? ? admin_discussions.for_content_requests : filter_only_viewable(admin_discussions.for_content_requests)
  end

  def current_viewable_request_discussions
    viewable_request_discussions.select { |discussion| Time.now >= discussion.scheduled_at }
  end
  
  private

  def all_discussions(find_options = {})
    restaurant.admin_discussions.all({:include => :discussionable}.merge(find_options)).select(&:discussionable)
  end

  def filter_only_viewable(collection)
    collection.select {|element| element.viewable_by? self }
  end

  def set_subject_matters_for_managers
    self.subject_matters = SubjectMatter.all
  end
  
end


