class Enrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :culinary_school
  accepts_nested_attributes_for :culinary_school

  def culinary_school_attributes_with_check=(attributes)
    return if culinary_school_id.present?
    culinary_school_attributes_without_check=(attributes)
  end
  alias_method_chain :culinary_school_attributes=, :check
end
