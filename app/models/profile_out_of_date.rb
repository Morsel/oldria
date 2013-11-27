class ProfileOutOfDate < ActiveRecord::Base
	attr_accessible :user_id, :restaurant_id, :count
end
