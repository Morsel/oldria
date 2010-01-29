class FeedsController < ApplicationController
  def index
    @feeds = Feed.featured.all
  end

end
