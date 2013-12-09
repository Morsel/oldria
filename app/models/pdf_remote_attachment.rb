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
#  credit                  :string(255)
#  position                :integer
#  name                    :string(255)
#

class PdfRemoteAttachment < RemoteAttachment

  VALID_CONTENT_TYPES = ["application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf"]
  attr_accessible :attachment,:attachment_content_type

  before_validation(:on => :save) do |file|
    if file.attachment_file_name.present? && (file.attachment_content_type == 'binary/octet-stream')
      mime_type = MIME::Types.type_for(file.attachment_file_name)
      file.attachment_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  validate :content_type, :if => Proc.new { |file| file.attachment_file_name.present? }

  def content_type
    errors.add(:attachment, "You need to convert that file to PDF to upload it") unless VALID_CONTENT_TYPES.include?(self.attachment_content_type)
  end

  validates_presence_of :attachment_file_name

  # validates_attachment_content_type :attachment, :content_type => "application/pdf", :message => "You need to convert that file to PDF to upload it"

  HUMAN_ATTRIBUTES = {
          :attachment_content_type => ""
  }

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end
end
