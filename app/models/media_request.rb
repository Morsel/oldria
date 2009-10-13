class MediaRequest < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_many :media_request_conversations
  has_many :recipients, :through => :media_request_conversations
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  validates_presence_of :sender_id
  
  accepts_nested_attributes_for :attachments
end
