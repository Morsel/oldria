# == Schema Information
# Schema version: 20120217190417
#
# Table name: enrollments
#
#  id              :integer         not null, primary key
#  school_id       :integer         not null
#  profile_id      :integer         not null
#  graduation_date :date
#  degree          :string(255)     default(""), not null
#  focus           :text
#  scholarships    :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Enrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :school
  accepts_nested_attributes_for :school, :reject_if => :reject_school_attributes?

  validates_presence_of :school, :profile_id
  attr_accessible :school_id, :school_attributes, :graduation_date, :degree, :focus, :scholarships,:confirmed_at

  private

  def reject_school_attributes?(attributes)
    # We don't care if the country is filled out, since it is pre-filled
    attributes.reject{|k,_| k == :country || k == "country" }.all? {|_,v| v.blank? } ||
    school_id.present?
  end
end
