require File.dirname(__FILE__) + '/../spec_helper'

describe RestaurantRole do
  should_have_many :employments
end
