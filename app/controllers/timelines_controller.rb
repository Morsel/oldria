class TimelinesController < ApplicationController
  before_filter :require_user
  before_filter :get_friend_activity, :except => [:twitter, :facebook, :activity_stream]

  ##
  # GET /timelines
  def index
    render :people_you_follow
  end

  ##
  # GET /timelines/twitter
  def twitter
    if current_user.twitter_authorized?
      @title = "Twitter"
      @posts = current_user.twitter_client.home_timeline
    end
    render :action => "activity_stream"
  end

  def facebook
    if current_user.facebook_authorized?
      @title = "Facebook"
      @posts = current_user.facebook_user.home
    end
    render :action => "activity_stream"
  end
  
  def activity_stream
    @title = "Activity Stream"
    tweets = current_user.twitter_client.friends_timeline if current_user.twitter_authorized?
    updates = current_user.facebook_user.home if current_user.facebook_authorized?
    @posts = (tweets.to_a + updates.to_a).sort { |a, b| creation(b) <=> creation(a) }[0..4]
  end  

  ##
  # GET /timelines/people_you_follow
  def people_you_follow
  end

  private

  def get_friend_activity
    @friend_activity = Status.friends_of_user(current_user).all
  end
  
  def creation(post)
    post.respond_to?(:updated_time) ? Time.parse(post['updated_time']) : Time.parse(post['created_at'])
  end
end
