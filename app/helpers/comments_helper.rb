module CommentsHelper
  def attachment_link(attached)
    return '' unless attached && attached.attachment_content_type
    link_to(attached.attachment_file_name, attached.attachment.url)
  end
end
