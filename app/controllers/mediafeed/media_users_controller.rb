class Mediafeed::MediaUsersController < Mediafeed::MediafeedController
  before_filter :require_media_user, :only => [:edit, :update]

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
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your profile."
      redirect_to edit_mediafeed_media_user_path(@user)
    else
      render :edit
    end
  end
  
  def confirm
    @user = User.find(params[:id])
  end
  
  def resend_confirmation
    render :template => 'users/resend_confirmation', :layout => 'mediafeed'
  end
  
  def forgot_password
    render :template => 'password_resets/new', :layout => 'mediafeed'
  end

end
