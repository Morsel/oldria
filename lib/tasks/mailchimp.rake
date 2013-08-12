namespace :mailchmp do
  desc "Add goups in groupings for list Media Prmotion newsletter."
  task :add_in_mpn => :environment do
    mc = MailchimpConnector.new("RIA Newsfeed") 
    puts "Loading.."
      mc.client.list_interest_groupings(:id => mc.media_promotion_list_id).each do |row| 
        if row["name"] == "Regions"
          JamesBeardRegion.all.each do |jbregion|
            mc.client.list_interest_group_add({:id=>mc.media_promotion_list_id,:group_name=>jbregion.name,:grouping_id=>row["id"]})
          end  
        end

        if row["name"] == "Promotions"
          PromotionType.all.each do |pt|
            mc.client.list_interest_group_add({:id=>mc.media_promotion_list_id,:group_name=>pt.name,:grouping_id=>row["id"]})
          end   
        end

        if row["name"] == "SubscriberType"
          mc.client.list_interest_group_add({:id=>mc.media_promotion_list_id,:group_name=>"Newsfeed",:grouping_id=>row["id"]})
          mc.client.list_interest_group_add({:id=>mc.media_promotion_list_id,:group_name=>"Digest",:grouping_id=>row["id"]})
        end

    end #End of groupings

=begin
      mc.client.list_subscribe(:id => mc.media_promotion_list_id, :email_address => "nishant.n@cisinlabs.com",:merge_vars => { :groupings => [{ :name => "promotions",:groups => "Beverage News"},{:name=>"regions",:groups=>"Pacific,test"}] },:replace_interests => true,:update_existing=>true)
=end

     puts "--------------Done."    
  end


desc "Add goups in groupings for list Media Prmotion newsletter."
  task :add_user_in_digest => :environment do
    mc = MailchimpConnector.new("RIA Media")
    User.media.each do |user|
      unless user.digest_writer.blank?
        signal = if user.media_newsletter_subscriptions.blank? && user.digest_writer.blank?
        "NO"
      else
        "YES"
      end      
      mc.client.list_subscribe(:id => mc.media_promotion_list_id, 
        :email_address => user.email,
        :merge_vars => {:FNAME=>user.first_name,
                        :LNAME=>user.last_name,                        
                        :MYCHOICE=>signal,                                              
        },:replace_interests => true,:update_existing=>true,:double_optin=>false)
      end  
    end 
  end   


desc "Add subscribers in Ria Newsfeed."
  task :add_user_in_ria_newsfeed => :environment do
     include ActionView::Helpers::TextHelper
    mc = MailchimpConnector.new("RIA Newsfeed")
    FasterCSV.read(ARGV[1],:headers => true,:col_sep => "\t").each do |row|
      email = row["Email Address"]
      @user = User.find_by_email(email)
      params ={}
      unless @user.blank?
          newsfeed_writer = NewsfeedWriter.find_by_name(row["WriterType"])
          if newsfeed_writer && @user.update_attributes(:newsfeed_writer=>newsfeed_writer)
            @user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'NewsfeedWriter'").map(&:destroy)
            @user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'NewsfeedWriter'").map(&:destroy)
            #@user.newsfeed_promotion_types.destroy_all

            if newsfeed_writer.id == 3 # For Local writer
              ma = MetropolitanArea.find_all_by_name(row["Metroareas"].split(",").map(&:lstrip).map(&:rstrip))
              ma.each do |metro_area|
                MetropolitanAreasWriter.create({:area_writer_type=>"NewsfeedWriter",:area_writer_id=>3,:user=>@user, :metropolitan_area => metro_area})
              end
            elsif newsfeed_writer.id == 2 #For Regional Writer
              JamesBeardRegion.id_or_name_in(row["Regions"].split(",").map(&:lstrip).map(&:rstrip)).each do |region| 
                  RegionalWriter.create({:regional_writer_type=> "NewsfeedWriter",:regional_writer_id=>2,:user=>@user,:james_beard_region=>region})
              end  

            end        
            params[:promotion_type_ids] = PromotionType.find_all_by_name(row["Promotions"].split(",").map(&:lstrip)).map(&:id)

            @user.update_attributes(params)
            @user = User.find_by_email(email)#reloading new object
            

            unless @user.newsfeed_writer.blank?
          
                region_metro_areas = MetropolitanArea.find(:all,:conditions=>["state in (?)", @user.newsfeed_writer.find_regional_writers(@user).map(&:james_beard_region).map(&:description).join(",").gsub(/[\s]*/,"").split(",")]).map(&:id).uniq #If user has selected regions, getting metros of regions
                
                mc.client.list_subscribe(:id => mc.media_promotion_list_id, 
                  :email_address => email,
                  :merge_vars => {:FNAME=>@user.first_name,
                                  :LNAME=>@user.last_name, 
                                  :METROAREAS=>@user.newsfeed_writer.find_metropolitan_areas_writers(@user).map(&:metropolitan_area_id).join(",").to_s + truncate(region_metro_areas.join(","),:length => 255), 
                                  :WRITERTYPE=>newsfeed_writer.name,           
                                  :groupings => [
                                      {:name=>"Regions",:groups=>@user.newsfeed_writer.find_regional_writers(@user).map(&:james_beard_region).map(&:name).join(",")},
                                      { :name => "SubscriberType",:groups => "Newsfeed"},
                                      {:name=>"Promotions",:groups=>@user.promotion_types.map(&:name).join(",")}]           
                  },:replace_interests => true,:update_existing=>true,:double_optin =>false)
                  
            end#End mc


            
        end 
      end       
    end     
  end 

end

