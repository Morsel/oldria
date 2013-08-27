class Category < ActiveRecord::Base
  belongs_to :carte
  # has_many :carte_categorizations, :dependent => :destroy
	has_many :items, :dependent => :destroy
	
	has_many :children, :class_name 'Category', :foreign_key 'parent_id'
  belongs_to :parent, :class_name 'Category', :foreign_key 'parent_id'

	validates_presence_of :name
  accepts_nested_attributes_for :items, :allow_destroy => true
  
	default_scope :order => 'parent_id Asc'
end
