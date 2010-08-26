# == Schema Information
# Schema version: 20100826212434
#
# Table name: nonculinary_enrollments
#
#  id                    :integer         not null, primary key
#  nonculinary_school_id :integer
#  profile_id            :integer
#  graduation_date       :date
#  field_of_study        :string(255)
#  degree                :string(255)
#  acheivements          :text
#  created_at            :datetime
#  updated_at            :datetime
#

class NonculinaryEnrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :nonculinary_school
  accepts_nested_attributes_for :nonculinary_school, :reject_if => :reject_school_attributes?

  validates_presence_of :nonculinary_school, :profile_id

  private

  def reject_school_attributes?(attributes)
    # We don't care if the country is filled out, since it is pre-filled
    attributes.reject{|k,_| k == :country || k == "country" }.all? {|_,v| v.blank? } ||
    nonculinary_school_id.present?
  end
end
