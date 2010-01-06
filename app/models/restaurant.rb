class Restaurant < ActiveRecord::Base
  default_scope :conditions => {:deleted_at => nil}

  belongs_to :manager, :class_name => "User"
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
  has_many :employments, :dependent => :destroy
  has_many :employees, :through => :employments
  has_many :additional_managers,
           :through => :employments,
           :source => :employee,
           :conditions => {:employments => {:omniscient => true}}
  has_many :media_request_conversations, :through => :employments

  after_validation_on_create :add_manager_as_employee

  def name_and_location
    [name, city, state].reject(&:blank?).join(", ")
  end

  def missing_subject_matters
    SubjectMatter.find(missing_subject_matter_ids)
  end

  def media_requests
    return [] if media_request_ids.blank?
    MediaRequest.scoped(:conditions => {:id => media_request_ids})
  end

  def media_request_ids
    return [] if media_request_conversations.blank?
    media_request_conversations.reject(&:blank?).map(&:media_request_id).uniq
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
end
