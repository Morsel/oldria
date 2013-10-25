#encoding: utf-8 
class ChangeNextEmailAtColumnValueToOneDayAgo < ActiveRecord::Migration
  def self.up
  	User.all.each do |user|
	  unless user.restaurants.blank?
	  	uves = user.user_visitor_email_setting
	  	unless uves.blank?
		  	uves.next_email_at = 1.day.ago
		  	uves.last_email_at = 1.day.ago
	  		uves.save
	  	else
	  		uves = user.build_user_visitor_email_setting
	  		uves.next_email_at = 1.day.ago
	  		uves.last_email_at = 1.day.ago
	  		uves.save
	  	end	  	
	  end  		
  	end
  end

  def self.down
  end
end
