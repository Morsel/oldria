class Soapbox::ProfilesController < Soapbox::SoapboxController
  before_filter :get_user, :check_access

  def show
    if (current_user && current_user.media?) && (@user && @user.employments.present? && !@user.employments.first.search_by_diner)
      flash[:notice] = "You don't have permission to access this page"
      redirect_to root_path
    end   
    # Is the current user following this person?
    @following = current_user.followings.first(:conditions => {:friend_id => @user.id}) if current_user
  end

  private

  def get_user
    if params[:username]
      @user = User.find_by_username(params[:username], :include => [:followings])
      raise ActiveRecord::RecordNotFound, "Couldn't find User with username=#{params[:username]}" if @user.nil?
    else
      @user = User.find(params[:id], :include => [:followings])
    end
  end
  
  def check_access
    unless @user.linkable_profile?
      flash[:error] = "#{@user.name_or_username} doesn't have a published profile yet."
      redirect_to soapbox_directory_path
    end
  end

end
