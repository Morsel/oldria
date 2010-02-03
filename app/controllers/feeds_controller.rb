class FeedsController < ApplicationController
  before_filter :require_user

  def show
    @feeds = current_user.chosen_feeds || Feed.featured.all
  end

  def edit
    @feed_categories = FeedCategory.all(:include => :feeds)
    @uncategorized_feeds = Feed.uncategorized.all
    @user_feed_ids = current_user.feed_ids
  end

  def update
    current_user.feed_ids = params[:feed_ids]
    redirect_to feeds_path
  end
end
