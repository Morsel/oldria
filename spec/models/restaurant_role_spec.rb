require_relative '../spec_helper'

describe RestaurantRole do
  should_have_many :employments
  should_validate_presence_of :name
end

