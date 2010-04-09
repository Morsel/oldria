# == Schema Information
# Schema version: 20100409155415
#
# Table name: trend_questions
#
#  id           :integer         not null, primary key
#  subject      :string(255)
#  body         :text
#  scheduled_at :datetime
#  expired_at   :datetime
#  criteria_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TrendQuestion < ActiveRecord::Base
  belongs_to :employment_search
  accepts_nested_attributes_for :employment_search
end
