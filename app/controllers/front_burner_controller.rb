class FrontBurnerController < ApplicationController

  before_filter :require_user

  def index
    if params[:all]
      @qotds = current_user.admin_conversations.current
      resto_trends = current_user.grouped_trend_questions.keys
      @trend_questions = (resto_trends.present? ? resto_trends : current_user.solo_discussions.current).sort_by(&:scheduled_at).reverse
    else
      @qotds = current_user.unread_qotds
      resto_trends = current_user.unread_grouped_trend_questions.keys
      @trend_questions = (resto_trends.present? ? resto_trends : current_user.unread_solo_discussions).sort_by(&:scheduled_at).reverse
    end
    @comment = Comment.find(params[:comment_id]) if comment_share?
  end

  private 

  def comment_share?
    (params[:post_to_facebook].to_s == "1") && params[:comment_id]
  end
end
