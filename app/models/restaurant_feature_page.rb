class RestaurantFeaturePage < ActiveRecord::Base
  has_many :restaurant_feature_categories

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"

  def deletable?
    restaurant_feature_categories.empty?
  end
end
# == Schema Information
#
# Table name: restaurant_feature_pages
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

