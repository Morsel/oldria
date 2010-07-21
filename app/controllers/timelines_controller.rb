class TimelinesController < ApplicationController
  before_filter :require_user
  before_filter :get_friend_activity, :except => :twitter

  ##
  # GET /timelines
  def index
    render :people_you_follow
  end

  ##
  # GET /timelines/twitter
  def twitter
    if current_user.twitter_authorized?
      @tweets = current_user.twitter_client.friends_timeline
    end
  end

  def facebook
    if current_user.facebook_authorized?
      @updates = current_user.facebook_user.home
    end
  end

  ##
  # GET /timelines/people_you_follow
  def people_you_follow
  end

  private

  def get_friend_activity
    @friend_activity = Status.friends_of_user(current_user).all
  end
end
