class MediaRequest < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_many :media_request_conversations
  has_many :recipients, :through => :media_request_conversations
  validates_presence_of :sender_id
end
