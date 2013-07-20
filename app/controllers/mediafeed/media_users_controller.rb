class Mediafeed::MediaUsersController < Mediafeed::MediafeedController
  before_filter :require_media_user, :only => [:edit, :update]
   before_filter :authorize, :only => [:edit, :update]
  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.has_role! :media
      @user.reset_perishable_token!
      UserMailer.deliver_signup(@user)
      redirect_to confirm_mediafeed_media_user_path(@user)
    else
      get_newsletter_data
      render :new
    end
  end

  def edit    
    get_newsletter_data    
  end

  def update      
     
    if @user.update_attributes(params[:user])
      @user.newsfeed_promotion_types.destroy_all if @user.newsfeed_writer.blank? #Deleting regiona promotion if user is not newsfeed regional writer
      update_newsletter_data(params[:id])
      @user.send_later(:update_media_newsletter_mailchimp)
      flash[:notice] = "Successfully updated your profile."
      redirect_to edit_mediafeed_media_user_path(@user)
    else
      get_newsletter_data
      render :edit
    end
  end

  def confirm
    @user = User.find(params[:id])
  end

  def resend_confirmation
    render :template => 'users/resend_confirmation'
  end

  def forgot_password
    render :template => 'password_resets/new'
  end

  def get_cities
      @selected_cities = []
      @cities = MetropolitanArea.find_all_by_state(params['state_name'])      
      @selected_cities = params[:user_id].blank? ? (current_user.metropolitan_areas if current_user) : (User.find(params[:user_id]).metropolitan_areas)
      render :layout => false
  end

  private

  def authorize 
    @user = User.find(params[:id])  
    if (cannot? :edit, @user) || (cannot? :update, @user)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @user and return
    end
  end

end

