require_relative '../spec_helper'

describe Cuisine do
  should_have_many :restaurants
  should_have_default_scope :order => "cuisines.name ASC"
  should_validate_presence_of :name

  should_have_scope :with_restaurants
end
