# == Schema Information
# Schema version: 20111014212116
#
# Table name: otm_keywords
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OtmKeyword < ActiveRecord::Base

  has_many :menu_item_keywords
  has_many :menu_items, :through => :menu_item_keywords

  validates_presence_of :name, :category

end
