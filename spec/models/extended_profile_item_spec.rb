# == Schema Information
# Schema version: 20100805194513
#
# Table name: extended_profile_items
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  category   :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ExtendedProfileItem do
  should_belong_to :profile
end
