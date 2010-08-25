class School < ActiveRecord::Base
  default_scope :order => "#{table_name}.name ASC"
  named_scope :culinary, :conditions => {:culinary => true}
  named_scope :nonculinary, :conditions => {:culinary => false}

  validates_presence_of :name, :city, :state, :country

  has_many :enrollments
  has_many :profiles, :through => :enrollments
end
