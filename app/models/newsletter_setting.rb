class NewsletterSetting < ActiveRecord::Base
	belongs_to :restaurant
	attr_accessible :introduction, :subject
end
