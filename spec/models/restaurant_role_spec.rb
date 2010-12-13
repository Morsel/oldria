require 'spec/spec_helper'

describe RestaurantRole do
  should_have_many :employments
  should_validate_presence_of :name
end

# == Schema Information
#
# Table name: restaurant_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  category   :string(255)
#

