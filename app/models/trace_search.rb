class TraceSearch < ActiveRecord::Base
	belongs_to :user
	attr_accessible :searchable_id, :searchable_type, :user_id, :term_name
end
