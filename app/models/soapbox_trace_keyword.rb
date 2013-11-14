class SoapboxTraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
	belongs_to :restaurant 
	attr_accessible :url, :title, :restaurant_id, :keywordable_type
end
