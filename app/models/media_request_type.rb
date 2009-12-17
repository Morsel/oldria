class MediaRequestType < ActiveRecord::Base
  has_many :media_requests
  
  
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