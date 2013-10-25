class TraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
	belongs_to :user
	attr_accessible :url, :title, :restaurant_id, :keywordable_type
end
