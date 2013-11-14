class SoapboxTraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
	belongs_to :restaurant 
	attr_protected
end
