# == Schema Information
#
# Table name: restaurant_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RestaurantRole < ActiveRecord::Base
  has_many :employments
  has_many :question_roles
  has_many :profile_questions, :through => :question_roles
  
  validates_presence_of :name
  
  default_scope :order => "#{table_name}.name ASC"
  named_scope :with_employments, :joins => :employments, :group => "#{table_name}.id"
end
