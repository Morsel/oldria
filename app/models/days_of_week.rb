class DaysOfWeek < ActiveRecord::Base
  belongs_to :carte
  belongs_to :day
end
