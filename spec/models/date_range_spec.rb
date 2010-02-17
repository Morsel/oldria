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

require 'spec/spec_helper'

describe DateRange do
  it "should be valid" do
    DateRange.new.should be_valid
  end
end
