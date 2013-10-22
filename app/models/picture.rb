# == Schema Information
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

class Picture < Asset

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
                    :url  => "/system/assets/pictures/:id/:style_:basename.:extension",
                    :path => ":Rails.root/public/system/assets/pictures/:id/:style_:basename.:extension",
	                  :styles => { :content => '575>', :thumb => '100x100#' }

	validates_attachment_size :data, :less_than => 4.megabytes
  attr_accessible :attachment, :photos_attributes, :name, :credit
  
	def url_content
	  url(:content)
	end

	def url_thumb
	  url(:thumb)
	end

	def to_json(options = {})
	  options[:methods] ||= []
	  options[:methods] << :url_content
	  options[:methods] << :url_thumb
	  super options
  end
end
