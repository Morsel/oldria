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

  validates_presence_of :name

  def keywords
    otm_keywords.map { |k| "#{k.category}: #{k.name}" }.to_sentence
  end

end
