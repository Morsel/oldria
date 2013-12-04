require_relative '../spec_helper'

describe JamesBeardRegion do
  should_have_many :restaurants
  should_have_many :users
  should_validate_presence_of :name
  should_validate_presence_of :description
end
