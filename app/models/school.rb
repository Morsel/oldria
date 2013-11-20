# == Schema Information
# Schema version: 20120217190417
#
# Table name: schools
#
#  id         :integer         not null, primary key
#  name       :string(255)     default(""), not null
#  city       :string(255)     default(""), not null
#  state      :string(255)     default(""), not null
#  country    :string(255)     default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class School < ActiveRecord::Base
  default_scope :order => "#{table_name}.name ASC"

  validates_presence_of :name, :city, :state, :country

  has_many :enrollments
  has_many :profiles, :through => :enrollments
  attr_accessible :name, :city, :state, :country
end
