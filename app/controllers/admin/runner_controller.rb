class Admin::RunnerController < Admin::AdminController
  def index

  	if params[:id].to_i == 1 
  		MediaNewsletterSubscription.new.send_newsletters_to_media
  		flash[:notice] = "Newsletter sent!"
      redirect_to :action => 'index'
  	end	
  	if params[:id].to_i == 2 
  		Promotion.last.send_newsfeed_newsletters_later
  		flash[:notice] = "Promotion email sent!"
      redirect_to :action => 'index'
  	end

  end

  def export_media_for_newsfeed
    @csv = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << %w[FirstName LastName Email NewsfeedWriterType PromotionType]
        User.media.each do |user|
        unless user.newsfeed_writer.blank?
            csv << [user.first_name ,
            user.last_name ,
            user.email ,
            user.newsfeed_writer.name,
              if user.newsfeed_writer.name=="Local Writer"
                user.newsfeed_writer.find_metropolitan_areas_writers(user).map(&:metropolitan_area).map(&:name).join(' ')
              else
                user.newsfeed_writer.find_regional_writers(user).map(&:james_beard_region).map(&:name).join(' ')
              end
            ]
        end
        end   
    end  
    send_data(@csv, :filename => "Newsfeed_for_media.csv")
  end  

  
  def export_media_for_digest
   @csv = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << %w[FirstName LastName Email DigestWriterType PromotionType]
        User.media.each do |user|
        unless user.digest_writer.blank?
            csv << [user.first_name ,
            user.last_name ,
            user.email ,
            user.digest_writer.name,
              if user.digest_writer.name=="Local Writer"
                user.digest_writer.find_metropolitan_areas_writers(user).map(&:metropolitan_area).map(&:name).join(' ')
              else
                user.digest_writer.find_regional_writers(user).map(&:james_beard_region).map(&:name).join(' ')
              end
            ]
        end
        end   
    end  
    send_data(@csv, :filename => "digest_for_media.csv") 
  end   
  def database_info
    if  params[:run_invitation_request]
      import_invitation_deltails
    elsif params[:restaurant_details] 
      import_restaurant_deltails
    elsif params[:chef_details]
      import_chef_details
    elsif params[:media_details]  
      import_media_details
    end  

  end  

  def import_invitation_deltails
    @csv = FasterCSV.generate(:col_sep => "\t") do |csv|
      csv << %w[FirstName LastName Email Restaurant Title Invitee Requested]
        Invitation.all.each do |invitation|
         csv << [invitation.try(:first_name),
            invitation.try(:last_name),
            invitation.try(:email),
            invitation.try(:restaurant_name),
            invitation.try(:title),
            invitation.try(:invitee).try(:name),
            invitation.created_at.try(:strftime, "%m/%d/%y") ]
        end   
      end   
    send_data(@csv, :filename => "Invitation Details.csv") 
  end   


  def import_restaurant_deltails
    @csv = FasterCSV.generate(:col_sep => "\t") do |csv| 
      csv << %w[Name Manager City State PhoneNumber CreatedAt FacebookPageUrl TwitterHandle]
      Restaurant.all.each do |restaurant|
        csv << [ restaurant.try(:name),
             restaurant.try(:manager).try(:name),
              restaurant.try(:city),
             restaurant.try(:state),
             restaurant.try(:phone_number),
             restaurant.created_at.try(:strftime, "%m/%d/%y"),
             restaurant.try(:facebook_page_url),
             restaurant.try(:twitter_handle)
        ]
      end 
    end  
    send_data(@csv, :filename => "Restaurant details.csv")   
  end 

  def import_chef_details
    @csv = FasterCSV.generate(:col_sep => "\t") do |csv| 
      csv << %w[Name Email LastRequestedAt FacebookPageUrl CreatedAt]
      User.all.each do |user|
        if user.has_chef_role?
          csv << [ user.try(:name),
            user.try(:email),
            user.try(:last_request_at).try(:strftime, "%m/%d/%y"),
            user.try(:facebook_page_url),
            user.created_at.try(:strftime, "%m/%d/%y")
         ]
        end   
      end   
    end   
    send_data(@csv, :filename => "User details.csv")   
  end   
 
  def import_media_details
   @csv = FasterCSV.generate(:col_sep => "\t") do |csv| 
     csv << %w[Name Email LastRequestedAt FacebookPageUrl CreatedAt]
      User.all.each do |user|
        if user.role == "media"
          csv << [ user.try(:name),
          user.try(:email),
          user.try(:last_request_at).try(:strftime, "%m/%d/%y"),
          user.try(:facebook_page_url),
          user.created_at.try(:strftime, "%m/%d/%y")
         ]
        end   
      end 
    end 
    send_data(@csv, :filename => "MediaUser details.csv")   
  end   


end


