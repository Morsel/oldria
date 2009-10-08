class MediaRequestConversation < ActiveRecord::Base
  belongs_to :recipient, :class_name => "User"
  belongs_to :media_request
end
