# == Schema Information
# Schema version: 20120217190417
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
  default_scope :order => 'position ASC'

  has_attached_file :image, :styles => { :full => "780x400#", :thumb => "50x50#", :spoonfeed => "974x400#", :hq_slide => "810x400#" }
    
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], 
      :if => :image_file_name
      
  validates_length_of :excerpt, :maximum => 200, 
      :too_long => "Please shorten the text to no more than 200 characters", 
      :allow_blank => true

  attr_accessible :image,:photo_credit,:title,:excerpt,:link

end
