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


  desc "Add goups in groupings for Lists RIA Newsfeed."
    task :add_user_in_newsfeed => :environment do
      User.media.each do |user|        
        user.newsfeed_mailchimp_update user,false
      end          
  end 

end

