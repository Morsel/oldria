#encoding: utf-8 
class ChangeUserSettingToDailyAssociatedRestaurant < ActiveRecord::Migration
  def self.up
  	User.all.each do |user|
	  unless user.restaurants.blank?
	  	uves = user.user_visitor_email_setting
	  	unless uves.blank?
		  	uves.email_frequency="Daily" 	  	
		  	uves.save
	  	else
	  		uves = user.build_user_visitor_email_setting
	  		uves.email_frequency="Daily" 	  	
		  	uves.save
	  	end
	  end  		
  	end
  end

  def self.down
  	User.all.each do |user|
	    unless user.restaurants.blank?
		  	uves = user.user_visitor_email_setting
		  	uves.email_frequency="Weekly" 	  	
		  	uves.save
	    end  		
  	end
  end
end
