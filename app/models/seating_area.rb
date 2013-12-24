# == Schema Information
# Schema version: 20120217190417
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
	attr_accessible :name, :occupancy, :restaurant_fact_sheet_id
end
