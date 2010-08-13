# == Schema Information
#
# Table name: cuisines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Cuisine < ActiveRecord::Base
  has_many :restaurants
  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"

  named_scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"

end
