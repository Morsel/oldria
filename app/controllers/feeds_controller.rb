class FeedsController < ApplicationController
  before_filter :require_user

  def show
    find_user_feeds
  end

  def edit
    find_user_feeds
    find_categorized_feeds
  end

  def update
    current_user.feed_ids = params[:feed_ids]
    redirect_to feeds_path
  end


  private

  def find_user_feeds
    @feeds = current_user.chosen_feeds || Feed.featured.all
    @user_feed_ids = @feeds.map(&:id)
  end

  def find_categorized_feeds
    @feed_categories = FeedCategory.all(:include => :feeds)
    @uncategorized_feeds = Feed.uncategorized.all
  end
end
