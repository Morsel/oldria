require_relative '../spec_helper'

describe School do
  should_validate_presence_of :city, :state, :country, :name
  should_have_many :enrollments
  should_have_many :profiles, :through => :enrollments
end

