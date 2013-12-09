require_relative '../spec_helper'

describe RestaurantRole do
  it { should have_many :employments }
  it { should validate_presence_of :name }
end

