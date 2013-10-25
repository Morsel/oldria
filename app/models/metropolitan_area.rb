# == Schema Information
# Schema version: 20120217190417
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
  has_many :trace_searches, :as => :keywordable
  
  has_and_belongs_to_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :state
  attr_accessible :name,:state
  
  default_scope :order => "LOWER(#{table_name}.state) ASC, LOWER(#{table_name}.name) ASC"

  scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"

  scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

  def to_label
    "#{state}: #{name}"
  end

  def city_and_state
    "#{name}, #{state}"
  end

end
