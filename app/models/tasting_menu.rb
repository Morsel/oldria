# == Schema Information
# Schema version: 20120217190417
#
# Table name: tasting_menus
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  price                    :string(255)
#  wine_supplement_price    :string(255)
#  restaurant_fact_sheet_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class TastingMenu < ActiveRecord::Base
  belongs_to :restaurant_tasting_menu
  attr_accessible :name, :price,:wine_supplement_price, :restaurant_fact_sheet_id
end

