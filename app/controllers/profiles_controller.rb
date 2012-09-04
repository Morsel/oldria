class ProfilesController < ApplicationController

  before_filter :require_user
  before_filter :find_user
  before_filter :find_or_build_profile, :only => [:edit, :edit_front_burner, :edit_account]
  
  def create
    @profile = @user.build_profile(params[:profile])

    if @profile.save
      flash[:notice] = "Successfully created profile."
      redirect_to profile_path(@user.username)
    else
      flash[:error] = "Please fix the errors in the form below"
      render :edit
    end
  end

  def edit
    @fb_user = current_facebook_user.fetch if current_facebook_user && @profile.user.facebook_authorized?
  end

  def edit_btl
    render :layout => false
  end

  def edit_front_burner
    @qotds = @user.admin_conversations.current.recent
    resto_trends = @user.grouped_trend_questions.keys
    @trend_questions = (resto_trends.present? ? resto_trends : @user.solo_discussions.current.recent).sort_by(&:scheduled_at).reverse
    render :layout => false
  end

  def update
    @profile = @user.profile

    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to edit_user_profile_path(:user_id => @user.id, :anchor => "profile-summary")
    else
      flash[:error] = "Please fix the errors in the form below"
      render :edit
    end
  end
  
  def toggle_publish_profile
    if current_user.update_attributes(:publish_profile => params[:publish_profile])
      render :partial => "shared/promotion_status"
    else
      render :partial => "shared/ajax_error" 
    end
  end

  def add_role_form
    render :partial => "profiles/add_role_form" 
  end  
  protected

  def find_user
    @user = User.find(params[:user_id])
    unauthorized! unless can?(:manage, @user)
  rescue CanCan::AccessDenied
    flash[:error] = "You are not authorized to access this page."
    redirect_to root_path
  end

  def find_or_build_profile
    @profile = @user.profile || @user.build_profile
  end

end
