class NewsfeedRegionalPromotionType < ActiveRecord::Base
	belongs_to :promotion_type
  belongs_to :user
end
