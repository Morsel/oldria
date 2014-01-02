require_relative '../spec_helper'

describe UserRestaurantVisitor do
  it { should belong_to :user }
	it { should belong_to :restaurant }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:user_restaurant_visitor)
  end

  it "should create a new instance given valid attributes" do
    UserRestaurantVisitor.create!(@valid_attributes)
  end

  describe ".profile_visitor" do
  	it "should return the user list who have visited users profile one day ago form current day" do
	  	user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
	    user.save(:validate => false)
	    restaurant = FactoryGirl.create(:restaurant)
	    UserRestaurantVisitor.profile_visitor(user,restaurant.id).should == UserRestaurantVisitor.find(:first,:conditions=>["user_id = ? and restaurant_id = ? ",user,restaurant.id])
    end 
  end


  describe "#get_full_day_name" do
  	it "should return the full day name according to there short name" do
	  	user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
	    user.save(:validate => false)
	    restaurant = FactoryGirl.create(:restaurant)
	    user_restaurant_visitor.get_full_day_name("Weekly",restaurant).should == "Monday"
	    user_restaurant_visitor.get_full_day_name("M",restaurant).should == "Monday"
	    user_restaurant_visitor.get_full_day_name("W",restaurant).should == "Wednesday"
	    user_restaurant_visitor.get_full_day_name("F",restaurant).should == "Friday"
    end
  end

  describe "#check_email_frequency" do
  	it "should return the email frequency" do
	  	user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
	    user.save(:validate => false)
	    restaurant = FactoryGirl.create(:restaurant)
	    uves = user.user_visitor_email_setting
	    days = uves.email_frequency.split("/")
	    days.each do |day_name|
	      day_name =="Daily"
	        uves.update_attributes(:next_email_at=>Chronic.parse("next day 12:00am"),:last_email_at=>Chronic.parse("this day 12:00am"))
	        user_restaurant_visitor.check_email_frequency(uves).should == uves
      end
    end
  end   

  describe "#getdayname" do
  	it "should return the day name" do
	  	user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	    date = Date.today.beginning_of_week + 3
	    week = date.strftime("%A")
	    user_restaurant_visitor.getdayname.should == week
    end
  end

  describe "#create_user_visited_email_setting" do
  	it "should create visitor email setting" do
	  	user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
	    user.save(:validate => false)
	    user_visitor_email_setting = user.build_user_visitor_email_setting
	    user_visitor_email_setting.next_email_at = Chronic.parse("next week Monday 12:00am")
	    user_visitor_email_setting.last_email_at = Chronic.parse("this week Monday 12:00am")
	    user_visitor_email_setting.email_frequency = "Weekly" 
	   FactoryGirl.create(:user_visitor_email_setting,:email_frequency=> user_visitor_email_setting.email_frequency,:next_email_at=>user_visitor_email_setting.next_email_at,:last_email_at=>user_visitor_email_setting.last_email_at)
    end
  end


  describe "#get_limit_day" do
  	it "should return true or false according to day name" do
  		user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)
	 		if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
  			it { respond_with 2 }
  			user_restaurant_visitor.get_limit_day.should == 2
  		end 	
  		if Date::ABBR_DAYNAMES[Date.today.wday] != "Mon" 	
  			user_restaurant_visitor.get_limit_day.should == 1
      end
    end
  end


  describe "#send_notification_to_chef_user" do
  	it "should send notification email to all chef users" do
  	  user_restaurant_visitor = FactoryGirl.build(:user_restaurant_visitor)
	  	user_restaurant_visitor.save(:validate => false)	
  	  user1 = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
  	  user1.save(:validate => false)
  	  user2 = FactoryGirl.build(:user, :username => 'sender1',:email=>"rewr1.23@gmail.com")
	   	user2.save(:validate => false)
	    User.all.each do |user|
	    	uves = user.user_visitor_email_setting
	    		if uves.blank?
            uves = FactoryGirl.create(:user_visitor_email_setting,:user=>user)
          end
          if ( Time.now > uves.next_email_at ) && ( !uves.do_not_receive_email ) && ( !["Sun","Sat"].include?(Date::ABBR_DAYNAMES[Date.today.wday]) )
          al_users= Array.new
          FactoryGirl.create(:trace_keyword,:keywordable_id=>25,:keywordable_type=>"RestaurantFeature",:user =>user )
          keywords =  TraceKeyword.all(:conditions => ["DATE(created_at) >= ? OR DATE(updated_at) >= ?" , 1.day.ago,1.day.ago]).group_by(&:keywordable_type)
          	specialties = cuisines = chapters = otmkeywords = restaurantfeatures = a_la_minute_visitors = nil
          	keywords.keys.each do |key|
          		if (key != "ALaMinuteAnswer")||(key != "ALaMinuteQuestion")
                instance_variable_set("@#{key.to_s.downcase.pluralize}", keywords[key].map(&:keywordable))
              end
                al_users = TraceKeyword.all(:conditions => ["(keywordable_type='ALaMinuteAnswer' OR keywordable_type='ALaMinuteQuestion') AND (DATE(created_at) >= ? OR DATE(updated_at) >= ?)" ,1.day.ago.beginning_of_day.to_formatted_s,1.day.ago.beginning_of_day.to_formatted_s]).map(&:user_id)
                a_la_minute_visitors = User.find(:all ,:conditions=>['id in (?)',al_users.flatten.compact.uniq])
                if user.restaurants.blank? 
                	if user.has_chef_role?
                		restaurant_visitors = {
				              "specialty_names" => specialties,
				              "cuisine_names" => cuisines,
				              "chapter_names" => chapters,
				              "otm_keywords" => otmkeywords,
				              "restaurant_features" => restaurantfeatures,
				              "a_la_minute_visitors" => a_la_minute_visitors,
				              "current_user" => user
				            }
				          if keywords.present? && user_restaurant_visitor.check_email_frequency(@uves)  
				          	 ActionMailer::Base.deliveries.should be_empty
				          	#ActionMailer::Base.deliveries.last.to.should == UserMailer.send_chef_user(restaurant_visitors).deliver 
				          end 
				        end   
                else
                	alm_visitors = Array.new
                	al_users = a_la_minute_visitors.map{|usr| usr if usr.digest_writer.present?}.compact
                	  al_users.each do |al_user|
					            if al_user.digest_writer.id==3
					              al_user.digest_writer.find_metropolitan_areas_writers(al_user).map(&:metropolitan_area_id).map{|id| alm_visitors.push(al_user) if user.restaurants.map(&:metropolitan_area_id).include? id}
					            elsif al_user.digest_writer.id==2
					              al_user.digest_writer.find_regional_writers(al_user).map(&:james_beard_region_id).map{|id| alm_visitors.push(al_user) if user.restaurants.map(&:james_beard_region_id).include? id}
					            else al_user.digest_writer.id==1
					              alm_visitors.push(al_user)
					            end 
				            end   
                userrestaurantvisitor = UserRestaurantVisitor.find(:all,:conditions=>["restaurant_id in (?) and updated_at > ?",user.restaurants.map(&:id),1.day.ago],:group => "restaurant_id")
	                userrestaurantvisitor.each do |visitor|
	                  unless visitor.blank?
	                  	visitors = visitor.restaurant.newsletter_subscribers
	                  	media_visitors = visitor.restaurant.restaurant_visitors.find(:all,:conditions=>["user_restaurant_visitors.created_at > ? OR user_restaurant_visitors.updated_at > ?",1.day.ago.beginning_of_day.to_formatted_s,1.day.ago.beginning_of_day.to_formatted_s])
	                  	menu = visitor.restaurant.menus.find(:first,:order =>"updated_at desc")
	                  	menu_item = visitor.restaurant.menu_items.find(:first,:order =>"updated_at desc")
	                  	newsfeeds = visitor.restaurant.promotions.find(:first,:conditions=>["created_at > ?",28.days.ago ],:order =>"created_at desc")
	                  	employee_visitors = user.trace_keywords.all(:conditions => ["DATE(created_at) >= ? ", 1.day.ago]).map(&:user)
	                  	otm_keyword_notification = OtmKeywordNotification.find(:all,:conditions=>["created_at > ?",1.day.ago])
	                  end 	
	                 	restaurant_visitors = {
			                "visitor_obj" =>visitor,
			                "userrestaurantvisitor" => visitors,
			                "media_visitors" => media_visitors,
			                "employee" => user,
			                "cuisine_names" => cuisines,
			                "employee_visitors" => employee_visitors,
			                "a_la_minute_visitors" => alm_visitors,
			                "restaurant" => visitor.restaurant,
			                "current_user" => user,
			                "otm_keyword_notification" => otm_keyword_notification 
			              } 
			              if user_restaurant_visitor.check_email_frequency(@uves)  
			                UserMailer.send_mail_visitor(restaurant_visitors).deliver
			                	ActionMailer::Base.deliveries.should be_empty
			                # @visitor_mail+=1
			                # create_log_file_for_visitor_user(user,visitor.restaurant)
			              end               
	                end 	
                end 
            	end 	
            end 	
	    end 	
    end
  end


end	

