class CarteFeatureItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :restaurant_feature
end
