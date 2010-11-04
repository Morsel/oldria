# == Schema Information
# Schema version: 20101104182252
#
# Table name: slides
#
#  id                 :integer         not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  title              :string(255)
#  excerpt            :text
#  link               :string(255)
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#  photo_credit       :string(255)
#  type               :string(255)
#

class Slide < ActiveRecord::Base

  has_attached_file :image, :styles => { :full => "780x400#", :thumb => "50x50#" }
    
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], 
      :if => :image_file_name
      
  validates_length_of :excerpt, :maximum => 140, 
      :too_long => "Please shorten the text to no more than 140 characters", 
      :allow_blank => true

end
