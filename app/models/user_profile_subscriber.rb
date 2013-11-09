class UserProfileSubscriber < ActiveRecord::Base
	belongs_to :user_profile_subscriber, :class_name => "User"  ,:foreign_key => "profile_subscriber_id"
	attr_protected
end
