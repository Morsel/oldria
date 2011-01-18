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
  
  def path_for_comment_delete(commentable, comment)
    commentable.is_a?(Admin::Conversation) ?
      admin_conversation_comment_path(commentable, comment) : 
      admin_discussion_comment_path(commentable, comment)
  end
  
  def title_and_restaurant(comment)
      comment.restaurant.present? ? 
        "#{comment.employment.restaurant_role.try(:name)} at #{restaurant_link(comment.restaurant)}" :
        "#{comment.employment.restaurant_role.try(:name)}"
  end
  
  def restaurant_name_for user
    # if (employment = user.primary_employment).present? && (restaurant = employment.restaurant).present?
    #       " of #{restaurant.name} "
    #     elsif employment && (name = employment.solo_restaurant_name).present?
    #       " of #{name} "
    #     else
      "&nbsp;"
    # end
  end

end
