namespace :importmediauser do
  desc "Import users from excel, to User table with media role."
  task :import => :environment do 
    puts "--------------Starting------------------------------"        
    require 'spreadsheet'    
    book = Spreadsheet.open('public/import/media_lst.xls')
    sheet1 = book.worksheet 'Sheet1'

    username = 123880

    jbr = {}
    JamesBeardRegion.all.map{|e| jbr[e.name.downcase]=e.id }.compact

    ma = {}
    MetropolitanArea.all.map{|e| ma[e.to_label.downcase] = e.id }.compact

    ma_without_state = {}
    MetropolitanArea.all.map{|e| ma_without_state[e.name.downcase] = e.id }.compact

    promotions = {}
    PromotionType.all.map{|e| promotions[e.name.downcase] = e.id }.compact

    file = File.open('public/import/media_lst.html', 'w') 
    
    file.puts "<html><body><H1>Some of the users not saved. Below is the list : </H1><br>"  
   
      sheet1.each 1 do |row|
        params = {:frist_name => (row[1].blank? ? "firstname" : row[1]),
                  :last_name => (row[2].blank? ? "lastname" : row[2]),
                  :email => row[3],
                  :username => username,
                  :publication => row[0],
                  :password =>"ria1234"
        }
        
        username +=1

        user = User.build_media_user(params)
        if user.confirm!
          if !row[6].blank? && row[6].downcase == "national"
            user.digest_writer_id = 1 
            user.save
          elsif (!row[6].blank? &&  jbr.keys.include?(row[6].downcase))
            user.digest_writer_id = 2
            user.save
            user.digest_writer.regional_writers.new({:user=>user,:james_beard_region_id=>jbr[row[6].downcase]}).save
          elsif (!row[6].blank? && (ma.keys.include? row[6].downcase))
            user.digest_writer_id = 3
            user.save
            user.digest_writer.metropolitan_areas_writers.new({:metropolitan_area_id=> ma[row[6].downcase], :user=>user}).save
          end  
          if (!row[4].blank? && (ma_without_state.keys.include? row[4].downcase))
            user.newsfeed_writer_id = 3
            user.save
            
            user.newsfeed_writer.metropolitan_areas_writers.new({:metropolitan_area_id=> ma_without_state[row[4].downcase], :user=>user}).save
            user.newsfeed_promotion_types.build({:promotion_type_id=>promotions[row[5].downcase]}).save
          end  

          puts " \n User saved #{params[:email]}\n"
        else
          file.puts "<ul>"
            file.puts "<li><strong>#{params[:email]}</strong></li>" 
            file.puts "<li>#{user.errors.full_messages.uniq.join('</li><li>')}</li>" 
          puts "***User not saved due to:\ #{params[:email]} #{user.errors.full_messages.to_s}***\n"
          file.puts "</ul>"
        end  
      end
      file.close()
     puts "--------------Done."    
  end

  desc "Remove, imported users with media role"
  task :delete_imported_users => :environment do 
    User.find_all_by_is_imported(true).map(&:destroy)
  end  

end

