#encoding: utf-8 
class UpdateLastEmailAtColumnToUserVisitorEmailSetting < ActiveRecord::Migration
  def self.up
    UserVisitorEmailSetting.all.each do |uves|
    	if uves.email_frequency=="Daily"	
		  uves.update_attributes(:last_email_at=>"#{Date.parse(uves.next_email_at.to_s).mjd-Date.parse(Time.now.to_s).mjd}".to_i.day.ago)
	    elsif uves.email_frequency=="M" || uves.email_frequency=="Weekly"
	      uves.update_attributes(:last_email_at=>"#{Date.parse(uves.next_email_at.to_s).mjd-Date.parse(Time.now.to_s).mjd}".to_i.day.ago)
	    elsif uves.email_frequency=="W"
	      uves.update_attributes(:last_email_at=>"#{Date.parse(uves.next_email_at.to_s).mjd-Date.parse(Time.now.to_s).mjd}".to_i.day.ago)
	    elsif uves.email_frequency=="F"
	      uves.update_attributes(:last_email_at=>"#{Date.parse(uves.next_email_at.to_s).mjd-Date.parse(Time.now.to_s).mjd}".to_i.day.ago)
	    end
    end
  end

  def self.down
  	UserVisitorEmailSetting.all.each do |uves|
    	uves.update_attributes(:last_email_at=>'')
    end
  end
end
