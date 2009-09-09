class FollowingsController < ApplicationController
  before_filter :require_user
  
  def create
    store_location
    @following = current_user.followings.build(:friend_id => params[:friend_id])
    if @following.save
      flash[:notice] = "You are now following #{@following.friend.name}"
    else
      flash[:error] = "Unable to follow that person"      
    end
    redirect_to root_url
  end
  
  def destroy
    @following = current_user.followings.find(params[:id])
    if @following.destroy
      flash[:notice] = "Successfully unfollowed"
    else
      flash[:error] = "Could not unfollow"
    end
    redirect_to root_url
  end
end
