module CommentsHelper
  def attachment_link(attached, options = {})
    return '' unless attached && attached.attachment_content_type
    link_to(attached.attachment_file_name, attached.attachment.url, options)
  end
end
