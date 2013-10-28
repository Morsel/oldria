# == Schema Information
#
# Table name: discussions
#
#  id                   :integer         not null, primary key
#  title                :string(255)
#  body                 :text
#  poster_id            :integer
#  comments_count       :integer         default(0)
#  created_at           :datetime
#  updated_at           :datetime
#  employment_search_id :integer
#

class Discussion < ActiveRecord::Base
  acts_as_commentable
  acts_as_readable

  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :comments, :attachments

  default_scope :order => "#{table_name}.created_at DESC"

  belongs_to :poster, :class_name => "User"
  has_many :discussion_seats, :dependent => :destroy
  has_many :users, :through => :discussion_seats, :uniq => true
  
  belongs_to :employment_search

  validates_presence_of :title
  attr_accessible :user_ids
  
  def posted_comments
    comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
  end

  scope :with_comments_unread_by, lambda { |user|
     { :joins => "INNER JOIN comments ON comments.commentable_id = discussions.id
       AND comments.commentable_type = 'Discussion'
       LEFT OUTER JOIN readings ON comments.id = readings.readable_id
       AND readings.readable_type = 'Comment'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL',
       :group => 'discussions.id' }
  }

  def inbox_title
    "Discussion"
  end
  
  def email_title
    inbox_title
  end

  def message
    title
  end

  def action_required?(user)
    comments_count > 0 && comments.last.user != user && !comments.last.read_by?(user)
  end

  ##
  # Never call this directly!
  def notify_recipients
    for user in self.users
      UserMailer.discussion_notification(self, user).deliver
    end
  end
  
end
