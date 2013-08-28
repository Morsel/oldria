class Carte < ActiveRecord::Base  
  
  has_many :days_of_weeks, :dependent => :destroy
  has_many :days, :through => :days_of_weeks

  # has_many :carte_categorizations, :dependent => :destroy
  # has_many :carte_categories, :through => :carte_categorizations
  has_many :categories, :dependent => :destroy
  
  belongs_to :restaurant
  

  accepts_nested_attributes_for :days, :allow_destroy => true
  accepts_nested_attributes_for :categories, :allow_destroy => true

  attr_accessible  :categories_attributes
  attr_accessible :name,:description,:start_time,:end_time,:start_date,:end_date,:note
  validates_presence_of :name
end