require 'spec_helper'

describe CulinarySchool do
  should_validate_presence_of :city, :state, :country, :name
end
