class Enrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :school
  accepts_nested_attributes_for :school, :reject_if => :reject_school_attributes?

  validates_presence_of :school, :profile_id

  private

  def reject_school_attributes?(attributes)
    attributes.all? {|_,v| v.blank? } || school_id.present?
  end
end
