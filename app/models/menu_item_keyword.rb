# == Schema Information
# Schema version: 20120217190417
#
# Table name: menu_item_keywords
#
#  id             :integer         not null, primary key
#  menu_item_id   :integer
#  otm_keyword_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class MenuItemKeyword < ActiveRecord::Base

  belongs_to :menu_item
  belongs_to :otm_keyword
  attr_accessible :menu_item_id, :otm_keyword_id
end
