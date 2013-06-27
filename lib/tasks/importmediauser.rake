namespace :importmediauser do
  desc "Import users from excel, to User table with media role."
  task :import => :environment do 
    puts "--------------Starting------------------------------"        
    require 'spreadsheet'    
    book = Spreadsheet.open('public/import/media_lst.xls')
    sheet1 = book.worksheet 'Sheet1'
    username = 123880
      sheet1.each 1900 do |row|
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
          puts " \nUser save #{params[:email]}\n"
        else
          puts "***User not saved due to:\ #{params[:email]} #{user.errors.full_messages.to_s}***\n"
        end  
      end
     puts "--------------Done."    
  end


end

