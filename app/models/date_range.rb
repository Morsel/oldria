# == Schema Information
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

class DateRange < ActiveRecord::Base
  has_many :coached_status_updates
  attr_accessible :start_date,:end_date,:name

end
