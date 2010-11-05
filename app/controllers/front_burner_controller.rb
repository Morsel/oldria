class FrontBurnerController < ApplicationController

  before_filter :require_user

  def index
    @qotds = current_user.admin_conversations.current
    @trend_questions = current_user.grouped_admin_discussions.keys || current_user.solo_discussions.current
  end

end
