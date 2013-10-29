class MetropolitanAreasWriter < ActiveRecord::Base
	 belongs_to :area_writer, :polymorphic => true
	 belongs_to :user
	 belongs_to :metropolitan_area
	 validates_presence_of :metropolitan_area_id 	
	 attr_accessible :user_id, :metropolitan_area_id
	 def removed_old_entries
	 	area_writer.find_metropolitan_areas_writers(user).map(&:destroy)
	 end

end


