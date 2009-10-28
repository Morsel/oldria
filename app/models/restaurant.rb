class Restaurant < ActiveRecord::Base
  belongs_to :manager, :class_name => "User"
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
end
