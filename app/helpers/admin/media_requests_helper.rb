module Admin::MediaRequestsHelper

  def list_and_link_replies(media_request)
    return "none" if media_request.discussions_with_comments.size == 0
    media_request.discussions_with_comments.map do |discussion|
      link_to discussion.restaurant.try(:name), media_request_discussion_path(discussion)
    end.join(", ")
  end
end
