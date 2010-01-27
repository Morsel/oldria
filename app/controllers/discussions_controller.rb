class DiscussionsController < ApplicationController
  before_filter :require_user

  def show
    @discussion = Discussion.find(params[:id])
  end

  def new
    @discussion = current_user.posted_discussions.build(:user_ids => [current_user.id])
    @users = current_user.coworkers
  end

  def create
    @discussion = current_user.posted_discussions.build(params[:discussion])
    if @discussion.save
      redirect_to root_url
    else
      render :new
    end
  end
end
