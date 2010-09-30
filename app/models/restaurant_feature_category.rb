class RestaurantFeatureCategory < ActiveRecord::Base
  has_many :restaurant_features

  belongs_to :restaurant_feature_page

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"

  def deletable?
    restaurant_features.empty?
  end
end
# == Schema Information
#
# Table name: restaurant_feature_categories
#
#  id                         :integer         not null, primary key
#  name                       :string(255)
#  restaurant_feature_page_id :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

