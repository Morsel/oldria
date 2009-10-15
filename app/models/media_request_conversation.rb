class MediaRequestConversation < ActiveRecord::Base
  acts_as_commentable
  accepts_nested_attributes_for :comments
  belongs_to :recipient, :class_name => "User"
  belongs_to :media_request
  
  def replies?
    comments_count > 0
  end
  
  def self.with_replies
    self.scoped(:conditions => "comments_count > 0")
  end
end
