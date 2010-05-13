# == Schema Information
#
# Table name: discussions
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  body           :text
#  poster_id      :integer
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
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

  validates_presence_of :title

  def posted_comments
    comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
  end

  named_scope :with_comments_unread_by, lambda { |user|
     { :joins => "INNER JOIN comments ON comments.commentable_id = discussions.id
       AND comments.commentable_type = 'Discussion'
       LEFT OUTER JOIN readings ON comments.id = readings.readable_id
       AND readings.readable_type = 'Comment'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL',
       :group => 'discussions.id' }
  }

  named_scope :unread_by, lambda { |user|
     { :joins => "LEFT OUTER JOIN readings ON discussions.id = readings.readable_id
       AND readings.readable_type = 'Discussion'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL' }
  }

  def inbox_title
    "Discussion"
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
      UserMailer.send_later(:deliver_discussion_notification, self, user)
    end
  end
end
