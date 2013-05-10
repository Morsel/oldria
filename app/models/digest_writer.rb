class DigestWriter < ActiveRecord::Base
	has_many :users
	has_many :metropolitan_areas_writers, :as => :area_writer	
	has_many :promotion_types_writers, :as => :promotion_writer
	has_many :regional_writers, :as => :regional_writer
	

	attr_accessible :metropolitan_areas_writers_attributes ,:promotion_types_writers_attributes ,:regional_writers_attributes
	accepts_nested_attributes_for :metropolitan_areas_writers ,:promotion_types_writers ,:regional_writers

	def find_metropolitan_areas_writers user
		metropolitan_areas_writers.find(:all,:conditions=>["user_id=?",user])
	end	

	def find_promotions_types_writers user
		promotion_types_writers.find(:all,:conditions=>["user_id=?",user])
	end

	def find_regional_writers user
		regional_writers.find(:all,:conditions=>["user_id=?",user])
	end
	
end
