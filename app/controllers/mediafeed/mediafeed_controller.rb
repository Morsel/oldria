class Mediafeed::MediafeedController < ApplicationController

  before_filter :require_media_user, :only => [:directory, :directory_search]
  before_filter :require_user, :only => [:request_information]
  
  def index
    redirect_to root_url(:subdomain => "spoonfeed")
  end
  
  def login
    redirect_to login_url(:subdomain => "spoonfeed")
  end
  
  def directory
    @use_search = true
    @users = User.in_soapbox_directory.all(:order => "users.last_name")

    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results", :locals => { :users => @users }
  end

  def request_information
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

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in with your media account first"
      redirect_to root_url
    end
  end

end
