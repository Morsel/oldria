class MediaNewsletterSetting < ActiveRecord::Base
	belongs_to :user
	attr_accessible :opt_out
end
