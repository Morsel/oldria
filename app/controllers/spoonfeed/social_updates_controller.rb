class Spoonfeed::SocialUpdatesController < ApplicationController

  before_filter :require_user

  def index
    @updates = SocialUpdate.all(:order => "post_created_at DESC").paginate(:page => params[:page], :per_page => 10)

    # kick off hourly delayed job to load/update posts from twitter/fb/etc
    if @updates.blank? || @updates.first.updated_at < 1.hour.ago
      SocialUpdate.send_later(:fetch_updates)
    end
  end

  def filter_updates
    @updates = SocialUpdate.all(:order => "post_created_at DESC",:conditions => {:source =>params[:source], :restaurant_id => Restaurant.search(params[:search]).relation.map(&:id)}).paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates", :locals => { :updates => @updates }
  end

  def expire_social_update
      expire_fragment('social_restaurant_search_criteria')
      redirect_to  :action => 'index'
  end 
end
