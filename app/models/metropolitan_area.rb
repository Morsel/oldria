# == Schema Information
# Schema version: 20101207003441
#
# Table name: metropolitan_areas
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class MetropolitanArea < ActiveRecord::Base
  has_many :restaurants
  has_many :profiles
  
  has_and_belongs_to_many :users
  
  validates_presence_of :name
  
  default_scope :order => "#{table_name}.state ASC, LOWER(#{table_name}.name) ASC"

  named_scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"

  named_scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

end
