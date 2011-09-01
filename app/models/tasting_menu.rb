# == Schema Information
# Schema version: 20110831230326
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
end
