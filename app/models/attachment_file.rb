# == Schema Information
#
# Table name: assets
#
#  id                :integer         not null, primary key, indexed => [type]
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer         indexed => [assetable_type], indexed => [assetable_type, type]
#  assetable_type    :string(25)      indexed => [assetable_id], indexed => [assetable_id, type]
#  type              :string(25)      indexed => [id], indexed => [assetable_id, assetable_type]
#  user_id           :integer         indexed
#  created_at        :datetime
#  updated_at        :datetime
#

class AttachmentFile < Asset

  # === List of columns ===
  #   id                : integer
  #   data_file_name    : string
  #   data_content_type : string
  #   data_file_size    : integer
  #   assetable_id      : integer
  #   assetable_type    : string
  #   type              : string
  #   locale            : integer
  #   user_id           : integer
  #   created_at        : datetime
  #   updated_at        : datetime
  # =======================

  has_attached_file :data,
                    :url => "/system/assets/attachments/:id/:filename",
                    :path => ":rails_root/public/system/assets/attachments/:id/:filename"

  validates_attachment_size :data, :less_than => 5.megabytes
end
