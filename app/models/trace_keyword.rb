class TraceKeyword < ActiveRecord::Base
	belongs_to :keywordable, :polymorphic => true
end
