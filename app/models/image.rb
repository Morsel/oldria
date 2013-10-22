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

class Image < Attachment

  belongs_to :attachable, :polymorphic => true

  validates_attachment_content_type :attachment,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
    :if => :attachment_file_name,
    :message => "Please upload a valid image type: .jpg, .png, .gif"

  has_attached_file :attachment,
    :storage => :s3,
    :styles => {
      :large => "640x640>",
      :medium => "320x320>",
      :small => "100x100>",
      :thumbnail => "40x40>",
      :thumb => "50x50>",
      :big_logo => "273x180>",
      :medium_photo => "189x150>",
      :restaurant_logo =>"215x150>"
    },
    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
    :path => "#{Rails.env}/images/:id/:style/:filename",
    :bucket => "spoonfeed",
    :url => ':s3_domain_url',
    :whiny => false,
    :default_url => '/images/avatar_restaurant.gif'

  attr_accessible :attachment, :photos_attributes, :name, :credit
  
  def restaurant
    attachable if attachable_type == "Restaurant"
  end

end
