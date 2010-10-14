require 'spec_helper'

describe School do
  should_validate_presence_of :city, :state, :country, :name
  should_have_many :enrollments
  should_have_many :profiles, :through => :enrollments
end

# == Schema Information
#
# Table name: schools
#
#  id         :integer         not null, primary key
#  name       :string(255)     default(""), not null
#  city       :string(255)     default(""), not null
#  state      :string(255)     default(""), not null
#  country    :string(255)     default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

