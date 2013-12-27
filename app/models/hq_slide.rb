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

class HqSlide < Slide
	attr_accessible :image_file_name, :image_content_type, :image_file_size, :image_updated_at , :position, :type
end

