require 'spec/spec_helper'

describe RestaurantRole do
  should_have_many :employments
  should_validate_presence_of :name
  should_have_default_scope :order => :name
end
