class UserRestaurantVisitor < ActiveRecord::Base
	 belongs_to :user, :dependent => :destroy
	 belongs_to :restaurant, :dependent => :destroy
    
      named_scope :profile_visitors, lambda { |restaurant_id|
	       	{ :conditions => ["restaurant_id = #{restaurant_id} and updated_at > '#{1.day.ago.beginning_of_day}'"]
	       }
   		}

	 def self.profile_visitor(user,restaurant_id)
      urv = UserRestaurantVisitor.find(:first,:conditions=>["user_id = ? and restaurant_id = ? ",user.id,restaurant_id])
      if urv.blank?          
           user.user_restaurant_visitors.create(:restaurant_id=>restaurant_id,:visitor_count=>1)
      else                
        urv.update_attributes(:visitor_count=>"#{urv.visitor_count+1}") 
      end 
	 end 	

	def self.send_notification
      userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["updated_at > ?",1.day.ago.beginning_of_day],:group => "restaurant_id")
      userrestaurantvisitor.each do |visitor|  
      	visitors = UserRestaurantVisitor.profile_visitors(visitor.restaurant_id) 
        media_visitors = visitor.restaurant.media_newsletter_subscriptions
        UserMailer.deliver_send_mail_visitor(visitor , visitors , media_visitors)
      end
    end 
end

