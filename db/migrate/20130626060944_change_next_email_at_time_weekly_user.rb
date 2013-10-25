#encoding: utf-8 
class ChangeNextEmailAtTimeWeeklyUser < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
    	uves=user.user_visitor_email_setting
		if !user.media? && user.restaurants.blank?
		  uves.update_attributes(:email_frequency=>"Weekly",:next_email_at=>Chronic.parse("next week Monday 12:00am"),:last_email_at=>2.day.ago)
	    end
    end
  end

  def self.down
  	User.all.each do |user|
  		uves=user.user_visitor_email_setting
    	uves.update_attributes(:last_email_at=>'')
    end
  end
end
