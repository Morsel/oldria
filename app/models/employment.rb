# == Schema Information
# Schema version: 20101104182252
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
#  primary              :boolean
#  type                 :string(255)
#  public_profile       :boolean
#  position             :integer
#  post_to_soapbox      :boolean         default(TRUE)
#  solo_restaurant_name :string(255)
#

class Employment < ActiveRecord::Base
  acts_as_list :scope => :restaurant

  belongs_to :employee, :class_name => "User"
  belongs_to :restaurant
  belongs_to :restaurant_role

  has_many :responsibilities, :dependent => :destroy
  has_many :subject_matters, :through => :responsibilities
  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'recipient_id'
  has_many :admin_discussions, :through => :restaurant
  has_many :admin_messages, :through => :admin_conversations, :class_name => 'Admin::Message'
  has_many :holiday_conversations, :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :holidays, :through => :holiday_conversations

  accepts_nested_attributes_for :employee

  validates_presence_of :employee_id
  validates_presence_of :restaurant_id, :unless => Proc.new { |e| e.type == "DefaultEmployment" }

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

  named_scope :handling_subject_matter_id, lambda { |subject_matter_id|
    {:joins => "LEFT OUTER JOIN responsibilities ON responsibilities.employment_id = employments.id",
      :conditions => ['responsibilities.subject_matter_id IN(?) OR omniscient = ?', subject_matter_id, true],
      :group => 'employments.id'}
  }

  named_scope :unique_users, :group => :employee_id

  named_scope :by_restaurant_name, :order => 'restaurants.name ASC, users.last_name ASC', :include => [:restaurant, :employee]
  named_scope :by_employee_last_name, :order => 'users.last_name ASC', :include => :employee
  named_scope :primary, :order => 'updated_at DESC', :limit => 1, :conditions => { :primary => true }

  named_scope :public_profile_only, :conditions => { :public_profile => true }
  named_scope :by_position, :order => "position ASC"

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

  def viewable_media_request_discussions
    if omniscient?
      conditions = {}
    else
      conditions = {:media_requests => {:subject_matter_id => subject_matter_ids}}
    end

    restaurant.media_request_discussions.all(:joins => :media_request,
      :conditions => conditions, :order => 'media_requests.created_at DESC')
  end

  def viewable_admin_discussions
    omniscient? ? all_media_requests : filter_only_viewable(all_media_requests)
  end

  def current_viewable_admin_discussions
    viewable_admin_discussions.select {|discussion| discussion.scheduled_at < Time.now }
  end

  private

  def all_media_requests(find_options = {})
    restaurant.admin_discussions.all({:include => :discussionable}.merge(find_options)).select(&:discussionable)
  end

  def filter_only_viewable(collection)
    collection.select {|element| element.viewable_by? self }
  end

end

