class NewsfeedLocalPromotionType < ActiveRecord::Base
	belongs_to :promotion_type
  belongs_to :user
end
