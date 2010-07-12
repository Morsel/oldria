# for external (cross-restaurant) group discussions
class ConversationsController < ApplicationController
  
  def new
    @discussion = current_user.posted_discussions.build(:user_ids => [current_user.id])
    @discussion.attachments.build
    search_setup(@discussion)
  end
end
