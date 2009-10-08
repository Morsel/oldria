class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  has_many :attachments, :as => :attachable
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  default_scope :order => 'created_at ASC'

  accepts_nested_attributes_for :attachments
end
