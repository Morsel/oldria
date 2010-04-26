module AttachmentsHelper

  ICON_FILE_TYPES = %w{doc gif html jpg pdf png tgz txt xml zip}.to_set

  def icon_image_for_attachment(attachment)
    return unless attachment
    if attachment.extname.present? and ICON_FILE_TYPES.include?(attachment.extname)
      "attachments/#{attachment.extname}.png"
    else
      'attachments/file.png'
    end
  end

end