module CommentsHelper
  def attachment_link(attached, options = {})
    return '' unless attached && attached.attachment_content_type
    link_to(attached.attachment_file_name, attached.attachment.url, options)
  end

  def path_for_comment_edit(commentable, comment)
    commentable.is_a?(Admin::Conversation) ?
      edit_admin_conversation_comment_path(commentable, comment) : 
      edit_admin_discussion_comment_path(commentable, comment)
  end
end
