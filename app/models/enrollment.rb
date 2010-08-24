class Enrollment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :culinary_school
  accepts_nested_attributes_for :culinary_school
end
