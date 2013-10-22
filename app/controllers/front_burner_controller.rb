class FrontBurnerController < ApplicationController

  before_filter :require_user
  require 'will_paginate/array'

  def index
    @user = current_user
    if params[:all]
      @qotds = @user.admin_conversations.current.paginate(:page => params[:page], :per_page => 5)
      resto_trends = @user.grouped_trend_questions.keys
      @trend_questions = (resto_trends.present? ? resto_trends : @user.solo_discussions.current).sort_by(&:scheduled_at).reverse.\
          paginate(:page => params[:page], :per_page => 5)
    else
      @qotds = @user.unread_qotds.paginate(:page => params[:page], :per_page => 5)
      resto_trends = @user.unread_grouped_trend_questions.keys
      @trend_questions = (resto_trends.present? ? resto_trends : @user.unread_solo_discussions).sort_by(&:scheduled_at).reverse.\
          paginate(:page => params[:page], :per_page => 5)
    end
    @comment = Comment.find(params[:comment_id]) if comment_share?
  end

  def user_qotds

    @user = User.find(params[:id])
    @keywordable_id = params[:id]
    @keywordable_type = 'User'
    @qotds = @user.qotd_convos_with_comments.all(:order => "created_at DESC")
  end

  def qotd
    @qotd = Admin::Qotd.find(params[:id])
    @answers = @qotd.comments.from_premium_users.all(:order => "created_at DESC")
  end

  private 

  def comment_share?
    (params[:post_to_facebook].to_s == "1") && params[:comment_id]
  end
end
