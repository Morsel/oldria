class RegionalWriter < ActiveRecord::Base
	belongs_to :regional_writer, :polymorphic => true
	belongs_to :user
	belongs_to :james_beard_region
	validates_presence_of :james_beard_region_id 	
	attr_accessible :user_id, :james_beard_region_id
	def removed_old_entries
		area_writer.find_metropolitan_areas_writers(user).map(&:destroy)
	end
end
