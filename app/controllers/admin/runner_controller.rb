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


end


