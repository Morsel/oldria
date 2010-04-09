# == Schema Information
# Schema version: 20100409221445
#
# Table name: trend_questions
#
#  id                   :integer         not null, primary key
#  subject              :string(255)
#  body                 :text
#  scheduled_at         :datetime
#  expired_at           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  employment_search_id :integer
#

require 'spec/spec_helper'

describe TrendQuestion do
  should_belong_to :employment_search
end
