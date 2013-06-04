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

# Commented as done by Nishant and not used anymore

  # def send_notification     

  #     userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["updated_at > ?",1.day.ago.beginning_of_day],:group => "restaurant_id")
  #     userrestaurantvisitor.each do |visitor|
  #       @menu_message = @fact_message = @menu_item = @menu_item_message = @a_la_minute_message = @newsfeed_message = nil
  #     if !visitor.restaurant.nil?
  #       visitors = visitor.restaurant.newsletter_subscribers 
      
  #       media_visitors = visitor.restaurant.restaurant_visitors  

  #       counter  = 0

  #       menu = visitor.restaurant.menus.find(:first,:order =>"updated_at desc")        
  #       if menu.blank? || (!menu.blank? && menu.updated_at < 30.day.ago)
  #         @menu_message = "Your restaurant's menus have not been updated for a month, please update your <a href='#{restaurant_menus_url(visitor.restaurant)}'>current menus</a>."
  #         counter +=1
  #       end

  #       if !visitor.restaurant.fact_sheet.blank? && visitor.restaurant.fact_sheet.created_at < 45.day.ago
  #         @fact_message = "Your restaurant's fact sheet is not up-to-date, please review this section of your <a href='#{edit_restaurant_fact_sheet_url(visitor.restaurant)}'>profile</a> so media have accurate information."
  #         counter +=1
  #       end 

  #       @menu_item = visitor.restaurant.menu_items.find(:first,:order =>"updated_at desc")
  #       unless @menu_item.blank?
  #         if @menu_item.created_at < 7.day.ago
  #           @menu_item_message = "You've never used On The Menu, a powerful tool for connecting with media. You can ,<a href='#{restaurant_menus_url(visitor.restaurant)}'>check it out here</a>"
  #           counter +=1
  #         end  
  #       else
  #         counter +=1 
  #         @menu_item_message = "Looks like you haven't uploaded a new dish or drink to On The Menu in quite some time. Let's keep media interested in you, <a href='#{new_restaurant_menu_url(visitor.restaurant)}'>add your newest dish or drink today!</a>"             
  #       end  

  #       @a_la_minute_answer = visitor.restaurant.a_la_minute_answers.find(:first,:conditions=>["created_at > ?",4.days.ago ],:order =>"created_at desc")
        
  #       if counter < 3 && @a_la_minute_answer.blank?
  #           @a_la_minute_message = "A la Minute helps you share your daily news directly with media. Keep them interested and up-to-date on what you are doing by filling out one or two items to <a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> each day!"
  #           counter +=1 
  #       else 
  #        if counter < 3 &&  @a_la_minute_answer.created_at > Time.now.beginning_of_day          
  #          @a_la_minute_message =  "Keep the media engaged and thinking about you, share your daily news on ,<a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> today!"
  #          counter +=1 
  #        end   
  #       end  

  #       @newsfeeds =  visitor.restaurant.promotions.find(:first,:conditions=>["created_at > ?",28.days.ago ],:order =>"created_at desc")
  #       if counter < 3 && @newsfeeds.blank?
  #         @newsfeed_message ="Newsfeed posts are emailed directly to media as press releases from your restaurant and can feature everything from new menu items to events to promos. Don't forget to get news to the ,<a href='#{new_restaurant_promotion_url(visitor.restaurant)}'>media</a> so they can report it."
  #       end

  #       keywords = TraceKeyword.all(:conditions => ["DATE(created_at) >= ? OR DATE(updated_at) >= ?" , 1.day.ago,1.day.ago]).group_by(&:keywordable_type)
  #       #keywords = TraceKeyword.all(:conditions => ["DATE(created_at) >= ?", 1.day.ago]).group_by(&:keywordable_type)
  #       @specialties = @cuisines =  @chapters = @otmkeywords = @restaurantfeatures  = nil

  #       keywords.keys.each do |key|
  #         if (key == "ALaMinuteAnswer")||(key == "ALaMinuteQuestion")
  #            @al_users = keywords[key].map(&:user_id)
  #            @_la_minute_visitors = UserRestaurantVisitor.find_all_by_user_id(@al_users)
  #            @_la_minute_visitors.each do |a_la_minute_visitor|
  #             if !a_la_minute_visitor.restaurant.nil?
  #              @a_la_minute_visitors = a_la_minute_visitor.restaurant.restaurant_visitors  
  #             end 
  #            end 
  #         else  
  #           instance_variable_set("@#{key.to_s.downcase.pluralize}", keywords[key].map(&:keywordable).map(&:name).to_sentence)
  #         end 
  #       end

  #       visitor.restaurant.employees.each do |employee|
  #        employee_visitors = employee.trace_keywords.all(:conditions => ["DATE(created_at) >= ? ", 1.day.ago]).map(&:user)

  #           restaurant_visitors = { 
  #             "visitor_obj" =>visitor,
  #             "userrestaurantvisitor" => visitors,
  #             "media_visitors" => media_visitors,
  #             "fact_message" =>@fact_message,
  #             "menu_message" => @menu_message,
  #             "menu_item_message" => @menu_item_message,
  #             "a_la_minute_message" =>@a_la_minute_message,
  #             "newsfeed_message" => @newsfeed_message,
  #             "employee" => employee,
  #             "specialty_names" => @specialties,
  #             "cuisine_names" => @cuisines,
  #             "chapter_names" => @chapters,
  #             "otm_keywords" => @otmkeywords,
  #             "restaurant_features" => @restaurantfeatures,
  #             "employee_visitors" => employee_visitors, 
  #             "alaminutequestions" => @alaminutequestions,
  #             "a_la_minute_visitors" => @a_la_minute_visitors,
  #             "restaurant" =>  visitor.restaurant,
  #             "current_user" => visitor.user,
  #             "users" => @users
  #           }  
  #           UserMailer.deliver_send_mail_visitor(restaurant_visitors)                      
  #     end 
  #   end  
  #  end
  # end  

  def send_notification_to_chef_user
    User.all.each do |user|
      # keyword trace if user chef is not associate to resturants or not
        keywords = TraceKeyword.all(:conditions => ["DATE(created_at) >= ? OR DATE(updated_at) >= ?" , 1.day.ago,1.day.ago]).group_by(&:keywordable_type)
        @specialties = @cuisines =  @chapters = @otmkeywords = @restaurantfeatures  = nil

        keywords.keys.each do |key|
          if (key == "ALaMinuteAnswer")||(key == "ALaMinuteQuestion")
             @al_users = keywords[key].map(&:user_id)
             @_la_minute_visitors = UserRestaurantVisitor.find_all_by_user_id(@al_users)
             @_la_minute_visitors.each do |a_la_minute_visitor|
              if !a_la_minute_visitor.restaurant.nil?
               @a_la_minute_visitors = a_la_minute_visitor.restaurant.restaurant_visitors  
              end 
             end 
          else  
            instance_variable_set("@#{key.to_s.downcase.pluralize}", keywords[key].map(&:keywordable).map(&:name).to_sentence)
          end 
        end
      if user.has_chef_role?        
        # check the chef is associated restaurants or not
        if user.restaurants.nil? || user.restaurants.blank?            
          restaurant_visitors = { 
            "specialty_names" => @specialties,
            "cuisine_names" => @cuisines,
            "chapter_names" => @chapters,
            "otm_keywords" => @otmkeywords,
            "restaurant_features" => @restaurantfeatures,
            "a_la_minute_visitors" => @a_la_minute_visitors,
            "current_user" => user
          }  
          UserMailer.deliver_send_chef_user(restaurant_visitors)
        end
        else         
          userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["updated_at > ?",1.day.ago.beginning_of_day],:group => "restaurant_id")
          userrestaurantvisitor.each do |visitor|
            @menu_message = @fact_message = @menu_item = @menu_item_message = @a_la_minute_message = @newsfeed_message = nil
        
            if !visitor.restaurant.nil?
              visitors = visitor.restaurant.newsletter_subscribers 
            
              media_visitors = visitor.restaurant.restaurant_visitors  

              counter  = 0

              menu = visitor.restaurant.menus.find(:first,:order =>"updated_at desc")        
              if menu.blank? || (!menu.blank? && menu.updated_at < 30.day.ago)
                @menu_message = "Your restaurant's menus have not been updated for a month, please update your <a href='#{restaurant_menus_url(visitor.restaurant)}'>current menus</a>."
                counter +=1
              end

              if !visitor.restaurant.fact_sheet.blank? && visitor.restaurant.fact_sheet.created_at < 45.day.ago
                @fact_message = "Your restaurant's fact sheet is not up-to-date, please review this section of your <a href='#{edit_restaurant_fact_sheet_url(visitor.restaurant)}'>profile</a> so media have accurate information."
                counter +=1
              end 

              @menu_item = visitor.restaurant.menu_items.find(:first,:order =>"updated_at desc")
              unless @menu_item.blank?
                if @menu_item.created_at < 7.day.ago
                  @menu_item_message = "You've never used On The Menu, a powerful tool for connecting with media. You can ,<a href='#{restaurant_menus_url(visitor.restaurant)}'>check it out here</a>"
                  counter +=1
                end  
              else
                counter +=1 
                @menu_item_message = "Looks like you haven't uploaded a new dish or drink to On The Menu in quite some time. Let's keep media interested in you, <a href='#{new_restaurant_menu_url(visitor.restaurant)}'>add your newest dish or drink today!</a>"             
              end  

              @a_la_minute_answer = visitor.restaurant.a_la_minute_answers.find(:first,:conditions=>["created_at > ?",4.days.ago ],:order =>"created_at desc")
              
              if counter < 3 && @a_la_minute_answer.blank?
                  @a_la_minute_message = "A la Minute helps you share your daily news directly with media. Keep them interested and up-to-date on what you are doing by filling out one or two items to <a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> each day!"
                  counter +=1 
              else 
               if counter < 3 &&  @a_la_minute_answer.created_at > Time.now.beginning_of_day          
                 @a_la_minute_message =  "Keep the media engaged and thinking about you, share your daily news on ,<a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> today!"
                 counter +=1 
               end   
              end  

              @newsfeeds =  visitor.restaurant.promotions.find(:first,:conditions=>["created_at > ?",28.days.ago ],:order =>"created_at desc")
              if counter < 3 && @newsfeeds.blank?
                @newsfeed_message ="Newsfeed posts are emailed directly to media as press releases from your restaurant and can feature everything from new menu items to events to promos. Don't forget to get news to the ,<a href='#{new_restaurant_promotion_url(visitor.restaurant)}'>media</a> so they can report it."
              end            
              visitor.restaurant.employees.each do |employee|
               employee_visitors = employee.trace_keywords.all(:conditions => ["DATE(created_at) >= ? ", 1.day.ago]).map(&:user)

                  restaurant_visitors = { 
                    "visitor_obj" =>visitor,
                    "userrestaurantvisitor" => visitors,
                    "media_visitors" => media_visitors,
                    "fact_message" =>@fact_message,
                    "menu_message" => @menu_message,
                    "menu_item_message" => @menu_item_message,
                    "a_la_minute_message" =>@a_la_minute_message,
                    "newsfeed_message" => @newsfeed_message,
                    "employee" => employee,
                    "specialty_names" => @specialties,
                    "cuisine_names" => @cuisines,
                    "chapter_names" => @chapters,
                    "otm_keywords" => @otmkeywords,
                    "restaurant_features" => @restaurantfeatures,
                    "employee_visitors" => employee_visitors, 
                    "alaminutequestions" => @alaminutequestions,
                    "a_la_minute_visitors" => @a_la_minute_visitors,
                    "restaurant" =>  visitor.restaurant,
                    "current_user" => visitor.user,
                    "users" => @users
                  }  
                  UserMailer.deliver_send_mail_visitor(restaurant_visitors)                      
              end 
            end
          end
        end
      end
  end

end

