class NonculinarySchool < ActiveRecord::Base
  has_many :nonculinary_enrollments
  has_many :profiles, :through => :nonculinary_enrollments
  validates_presence_of :name, :city, :state, :country
end
