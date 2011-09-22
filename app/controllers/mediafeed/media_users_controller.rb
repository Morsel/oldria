class Mediafeed::MediaUsersController < Mediafeed::MediafeedController
  before_filter :require_media_user, :only => [:edit, :update]

  def new
    @media_user = User.new(params[:user])
  end

  def create
    @media_user = User.new(params[:user])
    if @media_user.save
      @media_user.has_role! :media
      @media_user.reset_perishable_token!
      UserMailer.deliver_signup(@media_user)
      redirect_to mediafeed_user_confirmation_path
    else
      render :new
    end
  end

  def edit
    @media_user = User.find(params[:id])
  end

  def update
    @media_user = User.find(params[:id])
    if @media_user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your profile."
      redirect_to edit_mediafeed_media_user_path(@media_user)
    else
      render :edit
    end
  end
  
  def confirmation
  end
  
  def resend_confirmation
    render :template => 'users/resend_confirmation', :layout => 'mediafeed'
  end
  
  def forgot_password
    render :template => 'password_resets/new', :layout => 'mediafeed'
  end

end
