class Restaurant < ActiveRecord::Base
  belongs_to :manager, :class_name => "User"
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
  has_many :employments
  has_many :employees, :through => :employments

  def name_and_location
    [name, city, state].reject(&:blank?).join(", ")
  end
end
