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

require 'spec/spec_helper'

describe TrendQuestion do
  should_belong_to :employment_search
end
