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

class RemoteAttachment < Attachment
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
    :path => "#{Rails.env}/attachments/:id/:filename",
    :bucket => "spoonfeed",
    :url => ':s3_domain_url'
end
