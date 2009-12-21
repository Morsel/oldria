class FollowingsController < ApplicationController
  before_filter :require_user

  def create
    store_location
    @following = current_user.followings.build(:friend_id => params[:friend_id])
    if @following.save
      flash[:notice] = "OK! You are now following #{@following.friend.name}"
    else
      flash[:error] = "Unable to follow that person." + activerecord_error_list(@following.errors)
    end
    redirect_to root_url
  end
  
  def destroy
    @following = current_user.followings.first(:conditions => { :friend_id => params[:id] })
    if @following.destroy
      flash[:notice] = "OK, you aren't following them anymore."
    else
      flash[:error] = "Could not unfollow"
    end
    redirect_to root_url
  end

end
