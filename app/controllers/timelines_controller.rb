class TimelinesController < ApplicationController
  before_filter :require_user
  before_filter :get_friend_activity, :except => :twitter
  
  def index
    render :people_you_follow
  end

  def twitter
    @tweets = current_user.twitter_client.friends_timeline
  end

  def people_you_follow
  end
  
  private
  
  def get_friend_activity
    @friend_activity = Status.friends_of_user(current_user).all
  end

end
