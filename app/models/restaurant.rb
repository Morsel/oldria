class Restaurant < ActiveRecord::Base
  belongs_to :manager, :class_name => "User"
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
  has_many :employments
  has_many :employees, :through => :employments
  has_many :additional_managers,
           :through => :employments,
           :source => :employee,
           :conditions => {:employments => {:omniscient => true}}
  has_many :media_request_conversations, :through => :employments

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

  private

  def handled_subject_matter_ids
    employments.all(:include => :subject_matters).map(&:subject_matter_ids).flatten.uniq
  end

  def missing_subject_matter_ids
    (SubjectMatter.all(:select => :id).map(&:id) - handled_subject_matter_ids)
  end
end
