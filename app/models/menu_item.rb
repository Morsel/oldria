# == Schema Information
# Schema version: 20111017183828
#
# Table name: menu_items
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  description   :text
#  price         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  restaurant_id :integer
#

class MenuItem < ActiveRecord::Base

  belongs_to :restaurant

  has_many :menu_item_keywords
  has_many :otm_keywords, :through => :menu_item_keywords

  has_attached_file :photo,
                    :styles => { :full => "1966x2400>", :large => "360x480>", :medium => "240x320>", :thumb => "120x160>" }

  validates_attachment_content_type :photo,
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"],
      :message => "Please upload a valid image type: jpeg, gif, or png", :if => :photo_file_name

  validates_presence_of :name
  validates_format_of :price, :with => RestaurantFactSheet::MONEY_FORMAT

  def keywords
    otm_keywords.map { |k| "#{k.category}: #{k.name}" }.to_sentence
  end

end
