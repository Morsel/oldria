class FeedEntriesController < ApplicationController

  # PUT /feed_entries/1/read
  # This is meant to be called via AJAX
  def read
    @feed_entry = FeedEntry.find(params[:id])
    @feed_entry.read_by!(current_user) if current_user
    render :nothing => true
  end
end
