# == Schema Information
#
# Table name: restaurants
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  street1               :string(255)
#  street2               :string(255)
#  city                  :string(255)
#  state                 :string(255)
#  zip                   :string(255)
#  country               :string(255)
#  facts                 :text
#  created_at            :datetime
#  updated_at            :datetime
#  manager_id            :integer
#  metropolitan_area_id  :integer
#  james_beard_region_id :integer
#  cuisine_id            :integer
#  deleted_at            :datetime
#

class Restaurant < ActiveRecord::Base
  apply_addresslogic
  default_scope :conditions => {:deleted_at => nil}

  belongs_to :manager, :class_name => "User", :foreign_key => 'manager_id'
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
  has_many :employments, :dependent => :destroy
  has_many :employees, :through => :employments
  has_many :additional_managers,
           :through => :employments,
           :source => :employee,
           :conditions => {:employments => {:omniscient => true}}
  has_many :media_request_discussions
  has_many :media_requests, :through => :media_request_discussions
  has_many :admin_discussions, :dependent => :destroy
  has_many :holiday_discussions, :dependent => :destroy
  has_many :holidays, :through => :holiday_discussions

  has_many :trend_questions, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'TrendQuestion'
  has_many :content_requests, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'ContentRequest'

  has_many :events

  after_validation_on_create :add_manager_as_employee
  after_save :update_admin_discussions

  # For pagination
  cattr_reader :per_page
  @@per_page = 15

  def name_and_location
    [name, city, state].reject(&:blank?).join(", ")
  end

  def missing_subject_matters
    SubjectMatter.find(missing_subject_matter_ids)
  end

  def destroy_without_callbacks
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  # Override the default destroy to allow us to flag deleted_at.
  # This preserves the before_destroy and after_destroy callbacks.
  # Because this is also called internally by Model.destroy_all and
  # the Model.destroy(id), we don't need to specify those methods
  # separately.
  def destroy
    return false if callback(:before_destroy) == false
    result = destroy_without_callbacks
    callback(:after_destroy)
    result
  end

  def self.find_with_destroyed(*args)
    self.with_exclusive_scope { find(*args) }
  end

  def self.with_destroyed(&block)
    self.with_exclusive_scope(&block)
  end

  private

  def add_manager_as_employee
    self.employees << manager if manager
  end

  def handled_subject_matter_ids
    employments.all(:include => :subject_matters).map(&:subject_matter_ids).flatten.uniq
  end

  def missing_subject_matter_ids
    (SubjectMatter.all(:select => :id).map(&:id) - handled_subject_matter_ids)
  end

  def update_admin_discussions
    TrendQuestion.all.each(&:touch)
  end
end
