class VisitorEmailSetting < ActiveRecord::Base
	belongs_to :restaurant
	validates_presence_of :email_frequency
	validates_inclusion_of :email_frequency, :in => ["Daily","Weekly", "Biweekly", "Monthly"] ,:unless => "email_frequency.blank?"

	validates_presence_of :email_frequency_day,:if=>"!email_frequency.blank? && email_frequency !='Daily'"
  attr_accessible :restaurant_id, :is_approved,:email_frequency, :email_frequency_day, :last_email_at

	def next_email_frequency
   case email_frequency.downcase
    when "daily" 	    	
    	Time.now.tomorrow.at_beginning_of_day.to_formatted_s(:db)
    when "weekly"
      Chronic.parse("week #{email_frequency_day} 12:00am")
    when "biweekly"
      Chronic.parse("next week #{email_frequency_day} 12:00am")
    when "monthly"
      Chronic.parse("next month #{email_frequency_day} 12:00am")
    else      
      Chronic.parse("next #{email_frequency_day} 12:00am")
    end
  end

end


