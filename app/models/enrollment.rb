class Enrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :school
  accepts_nested_attributes_for :school

  def school_attributes_with_check=(attributes)
    return if school_id.present?
    school_attributes_without_check=(attributes)
  end
  alias_method_chain :school_attributes=, :check
end
