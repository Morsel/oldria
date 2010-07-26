class RequestCategorization < ActiveRecord::Base
  belongs_to :subject_matter
  belongs_to :media_request

  validates_uniqueness_of :subject_matter_id, :scope => :media_request_id
end
