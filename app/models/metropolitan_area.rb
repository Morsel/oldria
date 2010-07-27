# == Schema Information
#
# Table name: metropolitan_areas
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MetropolitanArea < ActiveRecord::Base
  has_many :restaurants
  default_scope :order => "LOWER(#{table_name}.name) ASC"

  named_scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"

end
