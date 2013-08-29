class UserKeyword < ActiveRecord::Base
	
	belongs_to :follow_keyword, :polymorphic => true
	validates_uniqueness_of :user_id, :scope => [:follow_keyword_id, :follow_keyword_type], :unless => Proc.new { |e| e.deleted_at.blank? }
	validates_presence_of :follow_keyword_id ,:follow_keyword_type
	belongs_to :user	
	named_scope :deleted_keywords, :conditions => "deleted_at IS NOT NULL"

	def update_user_keyword
		update_attributes({:deleted_at=> Time.now})
 	end
 	def delete_user_old_keywords
 		user.user_keywords.find(:all,:conditions => "deleted_at IS NOT NULL").map(&:destroy)
 	end	
	
end
