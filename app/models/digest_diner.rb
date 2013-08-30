class DigestDiner < ActiveRecord::Base

	has_many :metropolitan_areas_writers, :as => :area_writer	

	has_many :regional_writers, :as => :regional_writer
	
	has_many :newsletter_subscribers

	attr_accessible :metropolitan_areas_writers_attributes,:regional_writers_attributes
	accepts_nested_attributes_for :metropolitan_areas_writers ,:regional_writers

	def find_diner_regional_writers newsletter_subscriber
		regional_writers.find(:all,:conditions=>["newsletter_subscriber_id=?",newsletter_subscriber])
	end

	def find_diner_metropolitan_areas_writers newsletter_subscriber
		metropolitan_areas_writers.find(:all,:conditions=>["newsletter_subscriber_id=?",newsletter_subscriber])
	end
end
