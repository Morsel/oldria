# == Schema Information
#
# Table name: attachments
#
#  id                      :integer         not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  attachable_id           :integer         indexed => [attachable_type]
#  attachable_type         :string(255)     indexed => [attachable_id]
#  created_at              :datetime
#  updated_at              :datetime
#  credit                  :string(255)
#  position                :integer
#  name                    :string(255)
#

class RemoteAttachment < Attachment
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/environments/#{RAILS_ENV}/amazon_s3.yml",
    :path => "#{RAILS_ENV}/attachments/:id/:filename",
    :bucket => "spoonfeed",
    :url => ':s3_domain_url'
end
