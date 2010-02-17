# == Schema Information
#
# Table name: cuisines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

describe Cuisine do
  should_have_many :restaurants
  should_have_default_scope :order => :name
  should_validate_presence_of :name
end
