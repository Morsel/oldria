# == Schema Information
# Schema version: 20120217190417
#
# Table name: media_request_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  shortname  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  fields     :string(255)
#

class MediaRequestType < ActiveRecord::Base
  has_many :media_requests
  attr_accessible :name, :shortname, :fields   

  # Returns a parameterized array of strings 
  # from the comma separated list of field names
  # For example, if fields is "Jimmy Dean, Little girl"
  # fieldset will return # => ['jimmy_dean', 'little_girl']
  def fieldset
    @fieldset = (fields || "").split(/, */).map do |field|
      field.gsub(/\s+/, '_').downcase
    end
  end
end
