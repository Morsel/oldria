class TraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
	belongs_to :user
	attr_accessible :keywordable_id, :keywordable_type, :user_id, :count  

end
