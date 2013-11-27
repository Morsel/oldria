class SoapboxTraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
	belongs_to :restaurant 
	attr_accessible :keywordable_id, :keywordable_type, :user_id, :count, :restaurant_id, :url, :title  


end
