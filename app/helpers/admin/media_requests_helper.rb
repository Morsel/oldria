module Admin::MediaRequestsHelper

  def list_and_link_replies(media_request)
    return "none" if media_request.discussions_with_comments.size == 0
    media_request.discussions_with_comments.map do |discussion|
      discussion.is_a?(MediaRequestDiscussion) ?
        link_to(discussion.recipient_name, media_request_discussion_path(discussion)) :
        link_to(discussion.recipient_name, solo_media_discussion_path(discussion))
    end.join(", ")
  end
end
