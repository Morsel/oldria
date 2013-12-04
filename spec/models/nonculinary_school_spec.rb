require_relative '../spec_helper'

describe NonculinarySchool do
  should_validate_presence_of :city, :state, :country, :name
  should_have_many :nonculinary_enrollments
  should_have_many :profiles, :through => :nonculinary_enrollments
end

