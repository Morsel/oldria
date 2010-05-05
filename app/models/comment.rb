# == Schema Information
# Schema version: 20100316193326
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  acts_as_readable
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user
  default_scope :order => "#{table_name}.created_at ASC"

  accepts_nested_attributes_for :attachments

  named_scope :not_user, lambda { |user| {
    :conditions => ["user_id != ?", user.id]
  }}
  
  before_create :clear_read_status
  
  def clear_read_status
    if self.commentable_type == "Admin::Conversation"
      self.commentable.readings.each { |r| r.destroy }
    end
  end

end
