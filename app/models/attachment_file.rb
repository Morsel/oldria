# == Schema Information
# Schema version: 20120217190417
#
# Table name: assets
#
#  id                :integer         not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer
#  assetable_type    :string(25)
#  type              :string(25)
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_assets_on_id_and_type  (id,type)
#  fk_user                      (user_id)
#  fk_assets                    (assetable_id,assetable_type)
#  ndx_type_assetable           (assetable_id,assetable_type,type)
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
