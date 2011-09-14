# == Schema Information
# Schema version: 20110913204942
#
# Table name: nonculinary_schools
#
#  id         :integer         not null, primary key
#  name       :string(255)     default(""), not null
#  city       :string(255)     default(""), not null
#  state      :string(255)     default(""), not null
#  country    :string(255)     default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class NonculinarySchool < ActiveRecord::Base
  has_many :nonculinary_enrollments
  has_many :profiles, :through => :nonculinary_enrollments
  validates_presence_of :name, :city, :state, :country
end
