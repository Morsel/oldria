class CulinarySchool < ActiveRecord::Base
  attr_accessible :name, :city, :state, :country
  validates_presence_of :name, :city, :state, :country
  default_scope :order => "#{table_name}.name ASC"
end
