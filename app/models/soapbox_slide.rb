# == Schema Information
# Schema version: 20101019162841
#
# Table name: soapbox_slides
#
#  id                 :integer         not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :integer
#  title              :string(255)
#  excerpt            :text
#  link               :string(255)
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class SoapboxSlide < ActiveRecord::Base
  has_attached_file :image, :styles => { :full => "780x400#", :thumb => "50x50#" }
    
    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], 
      :if => :image_file_name
end
