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
#

class Image < Attachment
  validates_attachment_content_type :attachment, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], 
    :if => :attachment_file_name

  has_attached_file :attachment,
    :storage => :s3,
    :styles => {
      :medium => "300x300>"
    },
    :s3_credentials => "#{RAILS_ROOT}/config/environments/#{RAILS_ENV}/amazon_s3.yml",
    :path => "#{RAILS_ENV}/images/:id/:style/:filename",
    :bucket => "spoonfeed",
    :url => ':s3_domain_url',
    :whiny => false
end
