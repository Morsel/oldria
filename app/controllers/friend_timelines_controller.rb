class FriendTimelinesController < ApplicationController
  before_filter :require_user
  before_filter :require_twitter_authorization
  
  def show
    @tweets = current_user.twitter_client.friends_timeline
  end

end
