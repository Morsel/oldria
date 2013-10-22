# == Schema Information
#
# Table name: press_releases
#
#  id                       :integer         not null, primary key
#  title                    :string(255)
#  pdf_remote_attachment_id :integer
#  restaurant_id            :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class PressRelease < ActiveRecord::Base
  belongs_to :pdf_remote_attachment
  belongs_to :restaurant

  validates_presence_of :title
  validates_presence_of :pdf_remote_attachment

  accepts_nested_attributes_for :pdf_remote_attachment

  attr_accessible  :title, :pdf_remote_attachment_attributes
end
