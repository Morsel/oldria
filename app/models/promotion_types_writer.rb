class PromotionTypesWriter < ActiveRecord::Base
	belongs_to :promotion_writer, :polymorphic => true
	belongs_to :user
	belongs_to :promotion_type
	validates_presence_of :promotion_type_id 	,:user_id

	def removed_old_entries
	 	area_writer.find_metropolitan_areas_writers(user).map(&:destroy)	 
	end

end
