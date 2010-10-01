# == Schema Information
#
# Table name: attachments
#
#  id                      :integer         not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  attachable_id           :integer
#  attachable_type         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class PDFRemoteAttachment < RemoteAttachment
  validates_attachment_content_type :attachment, :content_type => "application/pdf", :message => "You need to convert that file to PDF to upload it."
end
