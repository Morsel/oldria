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

class Photo < Image
  validates_presence_of :credit
  validates_attachment_presence :attachment

  acts_as_list :scope => :attachable

  def activity_name
    "photo"
  end

end
