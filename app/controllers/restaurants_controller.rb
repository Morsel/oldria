class RestaurantsController < ApplicationController
  before_filter :require_user, :except =>[:media_user_newsletter_subscription]
  before_filter :authorize, :only => [:edit, :update, :select_primary_photo,
                                             :new_manager_needed, :replace_manager, :fb_page_auth,
                                             :remove_twitter, :download_subscribers, :activate_restaurant,:new_media_contact,:replace_media_contact,
                                             :fb_deauth,:newsletter_subscriptions,:api,:restaurant_visitors,:confirmation_screen,:import_csv]


  before_filter :find_restaurant, :only => [:twitter_archive, :facebook_archive, :social_archive,:media_subscribe]

  def index
    @employments = current_user.employments
    respond_to do |format|
      format.html
      format.js { auto_complete_restaurantkeywords }
    end
  end

  def new
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    find_or_initialize_restaurant if params[:restaurant]
  end

  def create
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    @restaurant.media_contact = current_user
    @restaurant.sort_name = params[:restaurant][:name]
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to bulk_edit_restaurant_employees_path(@restaurant)
    else
      render :add_restaurant
    end
  end

  def show
    find_activated_restaurant
    if current_user.media?
      UserRestaurantVisitor.profile_visitor(current_user,@restaurant.id)
    end
    
    @employments = @restaurant.employments.by_position.all(
        :include => [:subject_matters, :restaurant_role, :employee])
    @questions = ALaMinuteAnswer.public_profile_for(@restaurant)[0...3]
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 5)
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    @trend_answer = @restaurant.admin_discussions.for_trends.with_replies.first(:order => "created_at DESC")
  end

  def edit
    @fb_user = current_facebook_user.fetch if current_facebook_user && current_user.facebook_authorized?
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException,Exception => e
    Rails.logger.error("Unable to fetch Facebook user for restaurant editing due to #{e.message} on #{Time.now}")
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to @restaurant
    else
      flash[:error] = "We were unable to update the restaurant"
      render :edit
    end
  end

  def select_primary_photo
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to bulk_edit_restaurant_photos_path(@restaurant)
    else
      flash[:error] = "We were unable to update the restaurant"
      render :template => "photos/edit"
    end
  end

  def new_manager_needed
  end

  def new_media_contact
  end
   
  def replace_media_contact

    unless params[:media_contact].nil?
      new_media_contact = User.find(params[:media_contact])
      old_media_contact = @restaurant.media_contact 
      old_media_contact_employment = @restaurant.employments.find_by_employee_id(@restaurant.media_contact_id)
      
      if @restaurant.update_attribute(:media_contact_id, new_media_contact.id)
        flash[:notice] = "Updated account media contact "
      else
        flash[:error] = "Something went wrong. Our worker bees will look into it."
      end

      if old_media_contact == @restaurant.manager
        redirect_to new_manager_needed_restaurant_path(@restaurant) 
      else
        if(old_media_contact != new_media_contact && old_media_contact_employment.destroy)
          flash[:notice] = "Updated account media contact & #{new_media_contact.name} is deleted."        
        else
          flash[:notice] = "Could not deleted employee, as media contact remains same. "
        end  
        redirect_to bulk_edit_restaurant_employees_path(@restaurant)
      end  
    else
      flash[:error] = "You have to select a media contact."
      redirect_to new_media_contact_restaurant_path(@restaurant) and return
    end  
  end  

  def replace_manager
    old_manager = @restaurant.manager
    old_manager_employment = @restaurant.employments.find_by_employee_id(@restaurant.manager_id)
    new_manager = User.find(params[:manager])

    if @restaurant.media_contact == old_manager
      redirect_to new_media_contact_restaurant_path(@restaurant) and return
    end 
    
    if @restaurant.update_attribute(:manager_id, new_manager.id) && old_manager_employment.destroy
      flash[:notice] = "Updated account manager to #{new_manager.name}. #{old_manager.name} is no longer an employee."
    else
      flash[:error] = "Something went wrong. Our worker bees will look into it."
    end

    redirect_to bulk_edit_restaurant_employees_path(@restaurant)
  end

  def fb_page_auth

    if current_facebook_user  
      extended_token = @restaurant.extend_access_token(current_facebook_user.client.access_token)
      client = @restaurant.facebook_client(extended_token["access_token"])
      myself = @restaurant.fb_user_find(client)

      @page = myself.accounts.select { |a| a.id == params[:facebook_page] }.first 

      if @page
        @restaurant.update_attributes!(:facebook_page_id => @page.id,
                                       :facebook_page_token => @page.access_token,
                                       :facebook_page_url => @page.fetch.link)
        flash[:notice] = "Added Facebook page #{@page.name} to the restaurant"
      else
        @page = current_facebook_user
        if @page
          @restaurant.update_attributes!(:facebook_page_id => @page.id,
                                       :facebook_page_token => extended_token["access_token"],
                                       :facebook_page_url => @page.fetch.link)
          flash[:notice] = "Added Facebook page #{@page.name} to the restaurant"
        else  
          @restaurant.update_attributes!(:facebook_page_id => nil, :facebook_page_token => nil)
          flash[:notice] = "Cleared the Facebook page settings from your restaurant"
        end
      end
      redirect_to edit_restaurant_path(@restaurant)
    else
      flash[:notice] = "You need to login on facebook"
      redirect_to fb_auth_user_path(current_user, :restaurant_id => @restaurant.id)
    end 

    rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException ,Exception => e      
      Rails.logger.error("Unable to connect Facebook user account for #{@restaurant.name} due to #{e.message} on #{Time.now}")
      flash[:error] = "We were unable to connect your account. Please log back into Facebook if you are logged out, or try again later."
      redirect_to edit_restaurant_path(@restaurant)

  end

  def fb_deauth      
      @restaurant.update_attributes!(:facebook_page_id => nil,
                                       :facebook_page_token => nil)
      begin
        @page  = @restaurant.facebook_page.fetch if @restaurant.has_facebook_page?
        flash[:notice] = "Cleared the Facebook page #{@page.name} settings from your restaurant" unless @page.blank?
      rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException ,Exception => e  
        flash[:notice] = "Cleared the Facebook page  settings from your restaurant" 
      end 
      redirect_to edit_restaurant_path(@restaurant)  

  end

  def remove_twitter
    @restaurant.atoken  = nil
    @restaurant.asecret = nil
    if @restaurant.save
      flash[:message] = "Your Twitter account is no longer connected to your SpoonFeed restaurant account"
      redirect_to edit_restaurant_path(@restaurant)
    else
      render :edit
    end
  end

  def twitter_archive
  end

  def facebook_archive
  end

  def social_archive
  end

  def activate_restaurant
    if @restaurant.update_attributes(:is_activated => params[:mode])      
      flash[:notice] = params[:mode].to_i > 0  ? "Successfully activated restaurant" : "Successfully deactivated restaurant"
      redirect_to :restaurants
    else
      flash[:error] = "We were unable to update the restaurant"
      redirect_to :restaurants
    end
  end

  def newsletter_subscriptions
    @subscriptions = @restaurant.newsletter_subscriptions
    @media_subscriptions = @restaurant.media_newsletter_subscriptions
    unless @restaurant.premium_account?
      render "restaurants/_comming_soon"
    end
  end

  def download_subscribers
    @subscriptions = @restaurant.newsletter_subscriptions

    # csv string generator
    @csv = FasterCSV.generate(:col_sep => "\t") do |csv|
      # header
      csv << %w[first_name last_name email subscription_date]

      # subscribers
      @subscriptions.each do |subscription|
        csv << [subscription.newsletter_subscriber.first_name,
                subscription.newsletter_subscriber.last_name,
                subscription.newsletter_subscriber.email,
                subscription.created_at]
      end
    end

    send_data(@csv, :filename => "#{@restaurant.name} subscribers.csv")
  end

  def add_restaurant
    @restaurant = current_user.managed_restaurants.build
  end  

  def send_restaurant_request
    @restaurant = Restaurant.find(params[:id]) 
    @employment = Employment.find(:first,:conditions=>["employee_id = ? and restaurant_id = ? ",current_user ,@restaurant])

    if @restaurant && @employment.nil?
      @req = RestaurantEmployeeRequest.new({:restaurant_id=>@restaurant.id,:employee_id=>current_user.id})
      if(@req.save)
        UserMailer.deliver_employee_request(@restaurant, current_user)
        flash[:notice] = "We've contacted the restaurant manager. Thanks for setting up your account, and enjoy SpoonFeed!"
       else
        flash[:notice] = "Something went wrong or may be you already sent request to #{@restaurant.name
}."
       end
      else
        flash[:notice] = "Something went wrong or may be you already sent request to <b> #{@restaurant.name} </b>."           
    end
    redirect_to root_path
  end

  def restaurant_visitors      
      @visitors = []
      visitors = @restaurant.page_views.map(&:user).uniq!      
      @visitors = visitors.zip(@restaurant.restaurant_visitors).flatten.compact # old was .user_restaurant_visitors
      @visitors.uniq!

  end


  def import_csv  
    tmp_pwd = 'temp123' 
    @error_arr = []
    @rows = []
     
    (0..params[:first_name].count-1).each do |index,confirmation_key|
      index = index.to_s
      if  !params[:confirmation].blank? && params[:confirmation].keys.include?(index)
        nls = NewsletterSubscriber.find_by_email(params[:email][index])      
        if nls.nil?
          nls = NewsletterSubscriber.new(:first_name =>  params[:first_name][index],:last_name =>params[:last_name][index],:email => params[:email][index],:password=>tmp_pwd) 
          nls.save
        end
        
        unless nls.valid?
          @error_arr.push(nls.errors.full_messages.to_sentence)
          @rows.push({:first_name=>params[:first_name][index],:last_name=>params[:last_name][index],:email=>params[:email][index],:error=>true})
        else
          build_nls = nls.newsletter_subscriptions.build({:restaurant=>@restaurant})
          unless build_nls.save
            @error_arr.push(build_nls.errors.full_messages.to_sentence)
            @rows.push({:first_name=>params[:first_name][index],:last_name=>params[:last_name][index],:email=>params[:email][index],:error=>true})
          end               
        end
      else
        @rows.push({:first_name=>params[:first_name][index],:last_name=>params[:last_name][index],:email=>params[:email][index],:confirmation=>false})
      end


    end  
      if @error_arr.flatten.blank? 
        flash[:notice] = "Records successfully inserted."
        redirect_to newsletter_subscriptions_restaurant_path
      else
        flash.delete(:notice)
        flash[:error] = @error_arr.flatten.uniq.to_sentence
        render  :confirmation_screen
      end  
  end
  

  def api    
  end
    
  def media_subscribe     
    if current_user.media?   
      mnls = current_user.restaurant_newsletter_subscription(@restaurant)   
      if  mnls.blank? && MediaNewsletterSubscription.create(:media_newsletter_subscriber => current_user, :restaurant => @restaurant)
        flash[:notice] = "#{current_user.email} is now subscribed to #{@restaurant.name}'s newsletter."            
      else
        mnls.destroy          
        flash[:notice] = "#{current_user.email} is unsubscribed to #{@restaurant.name}'s newsletter."                    
      end
      current_user.send_later(:update_media_newsletter_mailchimp)
    end  
    redirect_to :action => "show", :id => @restaurant.id
  end

  def media_user_newsletter_subscription        

    @user = User.find(params[:id])    
    @arrMedia=[]    
    @basic_restarurants_menu_items = []
    @basic_restarurants_promotions = []
    @arrMedia.push(@user.media_newsletter_subscriptions.map(&:restaurant))
    @arrMedia.push(@user.get_digest_subscription)

    @arrMedia.flatten!
    @menu_items = @menus = @restaurantAnswers = @promotions = []
    unless(@arrMedia.blank?)
       @arrMedia.each do |restaurant|
         @basic_restarurants_menu_items << restaurant if !restaurant.premium_account? && !restaurant.menu_items.find(:all,:conditions=>["created_at >= ? OR updated_at >= ?",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day]).blank?
       end
       @arrMedia.each do |restaurant|
         @basic_restarurants_promotions << restaurant if !restaurant.premium_account? && !restaurant.promotions.find(:all,:conditions=>["created_at >= ? OR updated_at >= ?",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day]).blank?
       end

      @arrMedia = @arrMedia - @basic_restarurants_menu_items - @basic_restarurants_promotions

      @menu_items = MediaNewsletterSubscription.menu_items(@arrMedia)   
      @menus = MediaNewsletterSubscription.newsletter_menus(@arrMedia)  
      @fact_sheets = MediaNewsletterSubscription.fact_sheets(@arrMedia)  
      @photos = MediaNewsletterSubscription.photos(@arrMedia)  
      #@alaminute_answers = MediaNewsletterSubscription.restaurant_answers(@arrMedia)
      @promotions = MediaNewsletterSubscription.promotions(@arrMedia)
    end
    render :layout => false
  end
  
  def api    
  end
  
  def show_notice
    @restaurant = Restaurant.find(params[:restaurant_id])
    render :layout => false
  end

  def auto_complete_restaurantkeywords
    restaurant_keyword_name = params[:term]
    @restaurant_keywords = Restaurant.find(:all,:conditions => ["name like ?", "%#{restaurant_keyword_name}%"],:limit => 15)
    if @restaurant_keywords.present?
      render :json => @restaurant_keywords.map(&:name)
    else
      render :json => @restaurant_keywords.push('This restaurant does not yet exist in our database. Please try another restaurant.')
    end
  end

  def request_profile_update
    @restaurant = Restaurant.find( params[:restaurant_id])
    @restaurant.employments.each do |employment|
      if !employment.employee.user_visitor_email_setting.do_not_receive_email
        UserMailer.deliver_request_profile_update(@restaurant,employment.employee)
      end
    end
    user_id = current_user.id
    restaurant_id = params[:restaurant_id]
    @profile_out_of_date = ProfileOutOfDate.find_by_user_id_and_restaurant_id(user_id,restaurant_id)
    @profile_out_of_date = @profile_out_of_date.nil? ? ProfileOutOfDate.create(:user_id=>current_user.id,:restaurant_id=>params[:restaurant_id]) : @profile_out_of_date.increment!(:count)  
    flash[:notice] = "We've emailed the restaurant to let them know their profile is need to be update! As they update their profile, it will be reported on the Daily Dineline."
    redirect_to restaurant_path(@restaurant) 
  end  

 
  def confirmation_screen
    @error_arr =[]  
    @error_emails = []
    err_msg = ''
    @rows = []
    if (!params[:document].nil?)

       file_type = params[:document].original_filename.scan(/\.\w+$/)[0].to_s.gsub(".","")
        if file_type.to_s.downcase == "csv" 
          import_newletter_subscriber_csv
        elsif file_type.to_s.downcase == "xls"  
          import_newletter_subscriber_xls
        elsif file_type.to_s.downcase == "xlsx"  
          import_newletter_subscriber_xlsx  
        else
          flash[:error] = "Please select vaild csv or excel file."
          redirect_to newsletter_subscriptions_restaurant_path
        end          

        unless @error_arr.blank?
          flash[:error] = @error_arr.to_sentence
          redirect_to newsletter_subscriptions_restaurant_path
        end
         
    else
        flash[:error] = "Please select csv or excel file. "
        redirect_to newsletter_subscriptions_restaurant_path
    end  
  end  




  private

  def import_newletter_subscriber_csv
    begin
      file = params[:document]              
      FasterCSV.read(params[:document].path,:headers => true,:col_sep => "\t").each do |i|        
         @rows.push({:first_name=>i[0],:last_name=>i[1],:email=>i[2]})      
      end 
    rescue FasterCSV::MalformedCSVError    
      @error_arr.push("CSV file not in valid format.")     
    end

  end  


  def import_newletter_subscriber_xls
    begin
      file = params[:document]
      tmp_pwd = 'temp123' 
      Spreadsheet.client_encoding = 'UTF-8'
      xls = Spreadsheet.open file.path 
      sheet = xls.worksheet 0
      cn = 0
      sheet.each do |row|
         @rows.push({:first_name=>row[0],:last_name=>row[1],:email=>row[2]})         
      end  
    rescue 
      @error_arr.push("Excel file not in valid format.")
    end
  end    


  def import_newletter_subscriber_xlsx
    begin
      file = params[:document]
      tmp_pwd = 'temp123' 
      xls = SimpleXlsxReader.open file.path 
      xls.sheets.each do |sheet|
        sheet.rows.each do |row|
          @rows.push({:first_name=>row[0],:last_name=>row[1],:email=>row[2]})           
        end   
      end   
    rescue 
      @error_arr.push("Excel file not in valid format.")          
    end  
  end   

  def find_activated_restaurant    
    find_restaurant
    unless can?(:manage, @restaurant) || @restaurant.is_activated?
      flash[:notice] = "This restaurant is not available to view."
      redirect_to root_path and return
    end
  end

  def find_restaurant    
    @restaurant = Restaurant.find(params[:id])
  end  

  def authorize
    find_restaurant
    if (cannot? :edit, @restaurant) || (cannot? :update, @restaurant)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant and return
    end
  end

  def find_or_initialize_restaurant
    
    restaurant_name = params[:restaurant][:name]    
    @restaurants = Restaurant.find(:all, :conditions => ["name like ?", "%#{restaurant_name}%"])
    if @restaurants.blank?
      flash.now[:notice] = "We couldn't find them in our system. You can add this restaurant."
      render :add_restaurant
    else        
      flash.now[:notice] = "You can send request to this restaurant."
      render :restaurant_list  
    end  
  end  


end