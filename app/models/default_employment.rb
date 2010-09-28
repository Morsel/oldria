# == Schema Information
# Schema version: 20100928175957
#
# Table name: default_employments
#
#  id                 :integer         not null, primary key
#  employee_id        :integer
#  restaurant_role_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class DefaultEmployment < ActiveRecord::Base

  belongs_to :employee, :class_name => "User"
  belongs_to :restaurant_role
  
  has_many :responsibilities, :dependent => :destroy
  has_many :subject_matters, :through => :responsibilities

  validates_presence_of :employee_id, :restaurant_role_id
  validates_uniqueness_of :employee_id
  
  ### Preferences ###
  preference :post_to_soapbox, :default => true

end
