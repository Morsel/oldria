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
  has_many :follow_keywords ,:as => :follow_keyword ,:class_name =>'UserKeyword',:dependent => :destroy
  
  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"

  named_scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"
    
  named_scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

end
