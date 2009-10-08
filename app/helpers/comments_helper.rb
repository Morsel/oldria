module CommentsHelper
  def attachment_link(attached)
    if attached.attachment_content_type.match(/image/)
      link_to(image_tag(attached.attachment.url, :height => 16, :width => 16), attached.attachment.url)
    else
      link_to(attached.attachment_file_name, attached.attachment.url)
    end
  end
end
