class TimelinesController < ApplicationController
  def index
    render :template => 'timelines/people_you_follow'
  end

  def twitter
    @tweets = current_user.twitter_client.friends_timeline
  end

  def people_you_follow
    @friend_activity = Status.friends_of_user(@user).all
  end

end
