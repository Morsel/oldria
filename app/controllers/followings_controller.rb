class FollowingsController < ApplicationController
  before_filter :require_user

  def create
    #store_location
    @following = current_user.followings.build(:friend_id => params[:friend_id])
    if @following.save
      flash[:notice] = "OK! You are now following #{@following.friend.name}"
    else
      flash[:error] = "Unable to follow that person." + activerecord_error_list(@following.errors)
    end
    redirect_to root_url
  end
  
  def destroy
    @following = current_user.followings.find(params[:id])
    @user = @following.friend
    if @following.destroy
      flash[:notice] = "OK, you aren't following them anymore."
    else
      flash[:error] = "Could not unfollow"
    end
    redirect_to profile_path(@user.username)
  end

end
