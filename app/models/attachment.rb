# == Schema Information
# Schema version: 20120217190417
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
# Indexes
#
#  index_attachments_on_attachable_id_and_attachable_type  (attachable_id,attachable_type)
#

class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_attached_file :attachment

  def extname
    return @extname if defined?(@extname)
    @extname = attachment_file_name && File.extname(attachment_file_name).gsub(/^\.+/, "")
  end
end
