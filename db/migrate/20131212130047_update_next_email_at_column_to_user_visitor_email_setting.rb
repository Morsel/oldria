class UpdateNextEmailAtColumnToUserVisitorEmailSetting < ActiveRecord::Migration
  def self.up
    UserVisitorEmailSetting.all.each do |uves|
    	if uves.email_frequency=="Daily"	
		    uves.update_attributes(:next_email_at=>1.day.ago)
	    elsif uves.email_frequency=="Weekly"
	      uves.update_attributes(:next_email_at=>Chronic.parse("next week Monday 12:00am"),:last_email_at=>3.day.ago)
	    elsif uves.email_frequency=="M/W/F"
	      uves.update_attributes(:next_email_at=>Chronic.parse("this week Friday 12:00am"),:last_email_at=>1.day.ago)
      end
    end
  end

  def self.down
  	UserVisitorEmailSetting.all.each do |uves|
    	uves.update_attributes(:last_email_at=>'')
    end
  end
end
