class Spoonfeed::SocialUpdatesController < ApplicationController

  before_filter :require_user

  def index
    @updates = SocialPost.all(:order => "post_created_at DESC").paginate(:page => params[:page], :per_page => 10)

    # kick off hourly delayed job to load/update posts from twitter/fb/etc
    if @updates.blank? || @updates.first.updated_at < 1.hour.ago
      SocialPost.send_later(:fetch_updates)
    end
  end

  def filter_updates
    @updates = SocialPost.all(:conditions => { :restaurant_id => Restaurant.search(params[:search]).map(&:id)}).paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates", :locals => { :updates => @updates }
  end

end
