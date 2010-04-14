module DashboardHelper
  def discussion_comment_badge(discussion)
    return unless discussion
    comment_count = discussion.comments.find_unread_by(current_user).size
    return if comment_count.blank? or comment_count.zero?
    %Q{<div class="unread_comments_count"><span>#{comment_count}</span></div>}
  end
end
