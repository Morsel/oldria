class Carte < ActiveRecord::Base  
  
  has_many :days_of_weeks, :dependent => :destroy
  has_many :days, :through => :days_of_weeks

  # has_many :carte_categorizations, :dependent => :destroy
  # has_many :carte_categories, :through => :carte_categorizations
  has_many :categories, :dependent => :destroy
  
  belongs_to :restaurant
  
  validates_presence_of :name
  accepts_nested_attributes_for :days, :allow_destroy => true
  accepts_nested_attributes_for :categories, :allow_destroy => true

  attr_accessible  :categories_attributes

end