require 'spec_helper'

describe School do
  should_validate_presence_of :city, :state, :country, :name
  should_have_many :enrollments
  should_have_many :profiles, :through => :enrollments
  should_have_scope :culinary, :conditions => {:culinary => true}
  should_have_scope :nonculinary, :conditions => {:culinary => false}
end
