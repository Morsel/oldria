# == Schema Information
# Schema version: 20120217190417
#
# Table name: date_ranges
#
#  id         :integer         not null, primary key
#  start_date :date
#  end_date   :date
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_date_ranges_on_id  (id) UNIQUE
#

class DateRange < ActiveRecord::Base
  has_many :coached_status_updates
end
