class Mediafeed::MediafeedController < ApplicationController

  before_filter :require_media_user, :only => [:directory, :directory_search]
  before_filter :require_user, :only => [:request_information,:media_subscription]
  
  def initialize
    @per_page = 40
  end

  def index
    redirect_to root_url(:subdomain => "spoonfeed")
  end
  
  def login
    redirect_to login_url(:subdomain => "spoonfeed")
  end
  
  def directory
    @use_search = true
    @users = User.in_soapbox_directory.all(:order => "users.last_name")

    render :template => "directory/index",:layout => "application"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results", :locals => { :users => @users }
  end

  def request_information
    if !params[:menu_item_id].blank?
      @menu_item  = MenuItem.find(params[:menu_item_id])
      @restaurant = @menu_item.restaurant
      render :layout=>false if request.xhr?
    elsif !params[:promotion_id].blank?
      @promotion = Promotion.find(params[:promotion_id]) 
      @restaurant = @promotion.restaurant
      render :layout=>false if request.xhr?
    else
      message = "Request for more information about your #{params[:request_type]} post \"#{params[:request_title]}\""
      @direct_message = current_user.sent_direct_messages.build(:body => message)
      @direct_message.receiver = User.find(params[:user_id])
      if @direct_message.save
        flash[:notice] = "Your message has been sent!"
        redirect_to direct_message_path(@direct_message)
      else
        redirect_to :back
      end  
    end  
    
  end

  def request_info_mail   
    if params[:promotion].blank?
      menu_item  = MenuItem.find(params[:menu_item][:id])
      UserMailer.request_info_mail(params[:menu_item][:name],params[:menu_item][:description],menu_item.restaurant.media_contact,menu_item.restaurant,params[:comment],params[:subject],current_user).deliver     
      flash[:notice] = "Request has been sent!"
      redirect_to menu_items_path
    else
      promotion=Promotion.find(params[:promotion][:id])       
      UserMailer.request_info_mail(params[:promotion][:title],params[:promotion][:details],promotion.restaurant.media_contact,promotion.restaurant,params[:comment],params[:subject],current_user).deliver
      flash[:notice] = "Request has been sent!"
      redirect_to promotions_path
    end     
  end 
  
  def media_subscription
    @subscriptions = current_user.media_newsletter_subscriptions.map{|e| e unless e.restaurant.blank?}.compact.paginate({:page => params[:page], :per_page => @per_page})
    @digest_subsriptions = current_user.get_digest_subscription.paginate({:page => params[:page], :per_page => @per_page})
    @user = current_user
    @user.media_newsletter_setting || @user.build_media_newsletter_setting.save
    render :layout => 'application'

  end

  def media_all_unsubscribe     
    if current_user.media?   
      current_user.media_newsletter_subscriptions.map(&:destroy) 
      current_user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestWriter'").map(&:destroy)      
      current_user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestWriter'").map(&:destroy)
      current_user.update_attributes({:digest_writer_id => nil})
      current_user.send_later(:update_media_newsletter_mailchimp)  
      flash[:notice] = "Unsubscribed to all restaurants."                          
    end  
    redirect_to :action =>:media_subscription
  end

  def media_opt_update
    current_user.update_attributes(params[:user])
    flash[:notice] = "Setting saved successfully."
    redirect_to mediafeed_media_subscription_path  
  end

  def request_information_mail
  end  
 
  def add_comment

  end  

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in with your media account first"
      redirect_to root_url
    end
  end

end
