class SpoonfeedTraceSearche < ActiveRecord::Base
	belongs_to :user
	attr_accessible :searchable_id, :searchable_type, :term_name
end
