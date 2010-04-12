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
  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"
end
