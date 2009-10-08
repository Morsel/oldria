class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  default_scope :order => 'created_at ASC'

  accepts_nested_attributes_for :attachments
end
