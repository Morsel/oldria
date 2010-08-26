# == Schema Information
# Schema version: 20100825200638
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
#  culinary   :boolean
#

class School < ActiveRecord::Base
  default_scope :order => "#{table_name}.name ASC"
  named_scope :culinary, :conditions => {:culinary => true}
  named_scope :nonculinary, :conditions => {:culinary => false}

  validates_presence_of :name, :city, :state, :country

  has_many :enrollments
  has_many :profiles, :through => :enrollments
end
