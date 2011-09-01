# == Schema Information
# Schema version: 20110831230326
#
# Table name: seating_areas
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  occupancy                :integer
#  restaurant_fact_sheet_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class SeatingArea < ActiveRecord::Base
end
