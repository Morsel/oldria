# == Schema Information
# Schema version: 20120217190417
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
  has_many :profile_cuisines
  has_many :profiles, :through => :profile_cuisines
  has_many :trace_keywords, :as => :keywordable
  has_many :trace_searches, :as => :keywordable
  
  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"

  scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"
    
  scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

end
