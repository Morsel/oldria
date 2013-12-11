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

  def get_full_day_name(shortName,rest)
    if shortName=="Weekly"      
     return "Monday"
    elsif shortName=="M"
      return "Monday"
    elsif shortName=="W"
      return "Wednesday"
    elsif shortName=="F"
      return "Friday"
    end
  end

  def check_email_frequency(rest)
    days=rest.email_frequency.split("/")
    days.each do |day_name|
      if day_name=="Daily"
        # rest.update_attributes(:next_email_at=>Chronic.parse("next day 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
        return true
      end
      day_names=get_full_day_name(day_name,rest)
      if day_names==getdayname
        # begin update
        if day_name=="Weekly"      
          # rest.update_attributes(:next_email_at=>Chronic.parse("next week Monday 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
        elsif day_name=="M"
          # rest.update_attributes(:next_email_at=>Chronic.parse("this week Wednesday 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
        elsif day_name=="W"
          # rest.update_attributes(:next_email_at=>Chronic.parse("this week Friday 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
        elsif day_name=="F"
          # rest.update_attributes(:next_email_at=>Chronic.parse("next week Monday 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
        end
        # end update 
        return true
      end
    end
    return false
  end

  def getdayname
    return Date::DAYNAMES[Time.now.wday] # get the current day name
  end

  def create_user_visited_email_setting(user)
    user_visitor_email_setting = user.build_user_visitor_email_setting
    user_visitor_email_setting.email_frequency = "Weekly"
    user_visitor_email_setting.next_email_at = Chronic.parse("next week Monday 12:00am")
    user_visitor_email_setting.last_email_at = Chronic.parse("this week Monday 12:00am")
    user_visitor_email_setting.save
    user.user_visitor_email_setting
  end

  def send_notification_to_chef_user
    
    @connect_media = 0
    @visitor_mail = 0
    @visitor_mail_str = @connect_media_str = "" 
    # User.all.each do |user|
    user = User.find(1731)
      @uves=user.user_visitor_email_setting
        if @uves.blank?
          @uves=create_user_visited_email_setting(user)
        end
      if true #( Time.now > @uves.next_email_at ) && ( !@uves.do_not_receive_email ) && ( !["Sun","Sat"].include?(Date::ABBR_DAYNAMES[Date.today.wday]) )
        #keyword trace if user chef is not associate to resturants or not
        @al_users= Array.new
        keywords =  TraceKeyword.all(:conditions => ["DATE(created_at) >= ? OR DATE(updated_at) >= ?" , user.user_visitor_email_setting.last_email_at,user.user_visitor_email_setting.last_email_at]).group_by(&:keywordable_type)
        @specialties = @cuisines = @chapters = @otmkeywords = @restaurantfeatures = nil
        keywords.keys.each do |key|
          if (key != "ALaMinuteAnswer")||(key != "ALaMinuteQuestion")
            instance_variable_set("@#{key.to_s.downcase.pluralize}", keywords[key].map(&:keywordable))
          end
        end
        @al_users = TraceKeyword.all(:conditions => ["(keywordable_type='ALaMinuteAnswer' OR keywordable_type='ALaMinuteQuestion') AND (DATE(created_at) >= ? OR DATE(updated_at) >= ?)" ,get_limit_day.day.ago.beginning_of_day.to_formatted_s,get_limit_day.day.ago.beginning_of_day.to_formatted_s]).map(&:user_id)
        @a_la_minute_visitors = User.find(:all ,:conditions=>['id in (?)',@al_users.flatten.compact.uniq])
        if user.restaurants.blank? 
          # check the chef is associated restaurants or not
          if user.has_chef_role?
            restaurant_visitors = {
              "specialty_names" => @specialties,
              "cuisine_names" => @cuisines,
              "chapter_names" => @chapters,
              "otm_keywords" => @otmkeywords,
              "restaurant_features" => @restaurantfeatures,
              "a_la_minute_visitors" => @a_la_minute_visitors,
              "current_user" => user
            }
            if keywords.present? && check_email_frequency(@uves)
              # UserMailer.deliver_send_chef_user(restaurant_visitors) 
              @connect_media+=1
              create_log_file_for_connect_media(user)
            end
          end
        else
          @alm_visitors = Array.new
          @al_users = @a_la_minute_visitors.map{|usr| usr if usr.digest_writer.present?}.compact
          @al_users.each do |al_user|
            if al_user.digest_writer.id==3
              al_user.digest_writer.find_metropolitan_areas_writers(al_user).map(&:metropolitan_area_id).map{|id| @alm_visitors.push(al_user) if user.restaurants.map(&:metropolitan_area_id).include? id}
            elsif al_user.digest_writer.id==2
              al_user.digest_writer.find_regional_writers(al_user).map(&:james_beard_region_id).map{|id| @alm_visitors.push(al_user) if user.restaurants.map(&:james_beard_region_id).include? id}
            else al_user.digest_writer.id==1
              @alm_visitors.push(al_user)
            end              
          end
          
          userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["restaurant_id in (?) and updated_at > ?",user.restaurants.map(&:id),1.day.ago],:group => "restaurant_id")
          userrestaurantvisitor.each do |visitor|
          @menu_message = @fact_message = @menu_item = @menu_item_message = @a_la_minute_message = @newsfeed_message = nil
            
            if !visitor.restaurant.nil?
              visitors = visitor.restaurant.newsletter_subscribers
            
              media_visitors = visitor.restaurant.restaurant_visitors.find(:all,:conditions=>["user_restaurant_visitors.created_at > ? OR user_restaurant_visitors.updated_at > ?",1.day.ago.beginning_of_day.to_formatted_s,1.day.ago.beginning_of_day.to_formatted_s])

              counter = 0

              menu = visitor.restaurant.menus.find(:first,:order =>"updated_at desc")

              if menu.blank? || (!menu.blank? && menu.updated_at < 30.day.ago)
                @menu_message = "Your restaurant's menus have not been updated for more than a month, please update your <a href='#{restaurant_menus_url(visitor.restaurant)}'>current menus</a>."
                counter+=1
              end

              if !visitor.restaurant.fact_sheet.blank? && visitor.restaurant.fact_sheet.created_at < 45.day.ago
                @fact_message = "Your restaurant's fact sheet is not up-to-date, please review this section of your <a href='#{edit_restaurant_fact_sheet_url(visitor.restaurant)}'>profile</a> so media have accurate information."
                counter+=1
              end

              @menu_item = visitor.restaurant.menu_items.find(:first,:order =>"updated_at desc")
              unless @menu_item.blank?
                if @menu_item.created_at > 7.day.ago
                  @menu_item_message = "Looks like you've been working with On the Menu, keep at it!"
                  counter+=1
                elsif @menu_item.created_at < 7.day.ago
                  @menu_item_message = "Looks like you haven't uploaded a new dish or drink to On The Menu in quite some time. Let's keep media interested in you, <a href='#{new_restaurant_menu_url(visitor.restaurant)}'>add your newest dish or drink today!</a>"
                  counter+=1
                end 
              else
                counter+=1
                @menu_item_message = "You've never used On The Menu, a powerful tool for connecting with media. You can ,<a href='#{restaurant_menus_url(visitor.restaurant)}'>check it out here</a>"
              end

              @a_la_minute_answer = visitor.restaurant.a_la_minute_answers.find(:first,:conditions=>["created_at > ?",4.days.ago ],:order =>"created_at desc")
              
              if counter < 3 && @a_la_minute_answer.blank?
                  @a_la_minute_message = "A la Minute helps you share your daily news directly with media. Keep them interested and up-to-date on what you are doing by filling out one or two items to <a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> each day!"
                  counter+=1
              else
               if counter < 3 && @a_la_minute_answer.created_at > Time.now.beginning_of_day
                 @a_la_minute_message = "Keep the media engaged and thinking about you, share your daily news on ,<a href='#{bulk_edit_restaurant_a_la_minute_answers_url(visitor.restaurant)}'>A la Minute</a> today!"
                 counter+=1
               end
              end

              @newsfeeds = visitor.restaurant.promotions.find(:first,:conditions=>["created_at > ?",28.days.ago ],:order =>"created_at desc")
              if counter < 3 && @newsfeeds.blank?
                @newsfeed_message ="Newsfeed posts are emailed directly to media as press releases from your restaurant and can feature everything from new menu items to events to promos. Don't forget to get news to the ,<a href='#{new_restaurant_promotion_url(visitor.restaurant)}'>media</a> so they can report it."
              end
              otm_keyword_notification = OtmKeywordNotification.find(:all,:conditions=>["created_at > ?",user.user_visitor_email_setting.last_email_at]) 
              employee_visitors = user.trace_keywords.all(:conditions => ["DATE(created_at) >= ? ", 1.day.ago]).map(&:user)
              restaurant_visitors = {
                "visitor_obj" =>visitor,
                "userrestaurantvisitor" => visitors,
                "media_visitors" => media_visitors,
                "fact_message" =>@fact_message,
                "menu_message" => @menu_message,
                "menu_item_message" => @menu_item_message,
                "a_la_minute_message" =>@a_la_minute_message,
                "newsfeed_message" => @newsfeed_message,
                "employee" => user,
                "specialty_names" => @specialties,
                "cuisine_names" => @cuisines,
                "chapter_names" => @chapters,
                "otm_keywords" => @otmkeywords,
                "restaurant_features" => @restaurantfeatures,
                "employee_visitors" => employee_visitors,
                "alaminutequestions" => @alaminutequestions,
                "a_la_minute_visitors" => @alm_visitors,
                "restaurant" => visitor.restaurant,
                "current_user" => user,
                "sum" => @sum,
                "otm_keyword_notification" => otm_keyword_notification 
              }                          
              if check_email_frequency(@uves)  
                UserMailer.deliver_send_mail_visitor(restaurant_visitors) 
                @visitor_mail+=1
                create_log_file_for_visitor_user(user,visitor.restaurant)
              end
            end
          end
        end
      end      
    # end    
    write_the_file       
  end
  #TODU this method create log file of connect media and visitor email with  
  def write_the_file filename ="public/email_logs/visitor_email_#{Time.now.strftime("%d_%m_%Y")}.html"

    @file = File.open(filename, 'w')
    @file.puts "<html><body><H1>Below is the list of all user whoes gone mail today : </H1><br>"
    @file.puts "<ul>"
    @file.puts "<strong>Connect Media</strong><br/>" unless @connect_media.blank?
    @file.puts @connect_media_str
    @file.puts "<hr/><br/><strong>Visitor Email</strong><br/>" unless @visitor_mail_str.blank?
    @file.puts @visitor_mail_str
    @file.puts "</ul>"
    total_mail = @connect_media+@visitor_mail
    @file.puts "<h2>Detail of number of mail are</h2>"
    @file.puts "<ul>"
      @file.puts "<li>Connect media = #{@connect_media}</li>"
      @file.puts "<li>Visitor email = #{@visitor_mail}</li>"
      @file.puts "<li>Total Overall Mail = #{total_mail}</li>"
    @file.puts "</ul>"    
    @file.close()
  end 
  def create_log_file_for_connect_media(user)
    @connect_media_str = @connect_media_str+"<li>User Id         : #{user.id}</li>"
    @connect_media_str = @connect_media_str+"<li>User Name       : #{user.name}</li>"   
  end
  def create_log_file_for_visitor_user(user,restaurant)
    @visitor_mail_str = @visitor_mail_str+"<li>Restaurant Id   : #{restaurant.id}</li>"
    @visitor_mail_str = @visitor_mail_str+"<li>User Id         : #{user.id}</li>"
    @visitor_mail_str = @visitor_mail_str+"<li>User Name       : #{user.name}</li>"
  end  
  def add_exception_to_file(e)
    @file.puts "<h2><strong>The following exception were found during send the email</strong></h2>"
    @file.puts "<font color='red'> #{e.message} </font>"
  end

  #TODU test the write_file method
  def test_the_write_the_file
    @connect_media = "Test The Connect Media"
    @visitor_mail_str = "Visitor Email Testing"
    @connect_media = 1
    @visitor_mail = 1
    write_the_file "public/email_logs/visitor_email_test_#{Time.now.strftime("%d_%m_%Y")}.html"
  end
  def get_limit_day
    if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
      return 2
    else
      return 1  
    end 
  end
end