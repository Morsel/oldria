class UserRestaurantVisitor < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

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


	def send_notification      
      userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["updated_at > ?",1.day.ago.beginning_of_day],:group => "restaurant_id")

      userrestaurantvisitor.each do |visitor|
        visitors = visitor.restaurant.newsletter_subscribers 
        media_visitors = visitor.restaurant.restaurant_visitors  

        if visitor.restaurant.try(:fact_sheet).try(:created_at) < 45.day.ago
          @fact_message = "Your restaurant's fact sheet is not up-to-date, please review this section of your profile so media have accurate information."
        end         
        visitor.restaurant.menus.each do |menu| 
          if menu.updated_at < 30.day.ago
            @menu_message = "Your restaurant's menus have not been updated for a month, please update your current menus."
          end
        end

        @menu_item = visitor.restaurant.menu_items.find(:first,:order =>"updated_at desc")
        if @menu_item.blank?
          if @menu_item.created_at < 7.day.ago
            @menu_item_message = "Looks like you haven't uploaded a new dish or drink to On The Menu in quite some time. Let's keep media interested in you,add your newest dish or drink today!"
          end  
        else            
            @menu_item_message = "You've never used On The Menu, a powerful tool for connecting with media. You can ,check it out here" 
        end  

        @a_la_minute_answer = visitor.restaurant.a_la_minute_answers.find(:first,:conditions=>["created_at > ?",4.days.ago ],:order =>"created_at desc")
        
        if @a_la_minute_answer.blank?
            @a_la_minute_message = "A la Minute helps you share your daily news directly with media. Keep them interested and up-to-date on what you are doing by filling out one or two items to A la Minute each day!"
        else 
         unless @a_la_minute_answer.created_at < Time.now.beginning_of_day          
           @a_la_minute_message =  "Keep the media engaged and thinking about you, share your daily news on ,A la Minute today!"
         end   
        end  

        @newsfeeds =  visitor.restaurant.promotions.find(:first,:conditions=>["created_at > ?",28.days.ago ],:order =>"created_at desc")
        if @newsfeeds.blank?
          @newsfeeds ="Newsfeed posts are emailed directly to media as press releases from your restaurant and can feature everything from new menu items to events to promos. Don't forget to get news to the ,media so they can report it."
        end

      UserMailer.deliver_send_mail_visitor(visitor,visitors,media_visitors,@fact_message,@menu_message,@menu_item_message,@a_la_minute_message,@newsfeed_message)
   end
  end  
end

