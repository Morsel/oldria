# == Schema Information
#
# Table name: james_beard_regions
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec/spec_helper'

describe JamesBeardRegion do
  should_have_many :restaurants
  should_have_many :users
  should_validate_presence_of :name
  should_validate_presence_of :description
end
