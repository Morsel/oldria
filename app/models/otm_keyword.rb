# == Schema Information
# Schema version: 20120217190417
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

  has_many :menu_item_keywords, :dependent => :destroy
  has_many :menu_items, :through => :menu_item_keywords
  has_many :trace_searches, :as => :keywordable

  validates_presence_of :name, :category
  attr_accessible :name,:category


  def name_with_category
    "#{category}: #{name}"
  end

end
