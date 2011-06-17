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
      if comment.restaurant.present?
        "#{comment.employment.restaurant_role.try(:name)} at #{restaurant_link(comment.restaurant)}"
      elsif comment.employment.solo_restaurant_name.present?
        "#{comment.employment.restaurant_role.try(:name)} at #{comment.employment.solo_restaurant_name}"
      else
        comment.employment.restaurant_role.try(:name)
      end
  end
  
  def title_and_restaurant_name_for resource, user
    if user.media?
      " #{resource.media_request.publication || user.publication} "
    elsif resource.is_a?(MediaRequestDiscussion)
      mr_restaurant = resource.restaurant
      ", #{user.employments.find_by_restaurant_id(mr_restaurant.id).try(:restaurant_role).try(:name)} of #{mr_restaurant.try(:name)} "
    elsif (employment = user.primary_employment).present? && (restaurant = employment.restaurant).present?
      ", #{employment.try(:restaurant_role).try(:name)} of #{restaurant.try(:name)} "
    elsif employment && (name = employment.solo_restaurant_name).present?
      " of #{name} "
    else
      "&nbsp;"
    end
  end

end
