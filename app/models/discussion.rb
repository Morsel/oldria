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
  accepts_nested_attributes_for :comments

  belongs_to :poster, :class_name => "User"
  has_many :discussion_seats, :dependent => :destroy
  has_many :users, :through => :discussion_seats, :uniq => true

  validates_presence_of :title

  after_create :notify_recipients

  def posted_comments
    comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
  end

  named_scope :with_comments_unread_by, lambda { |user|
     { :joins => "INNER JOIN comments ON comments.commentable_id = discussions.id
       AND comments.commentable_type = 'Discussion'
       LEFT OUTER JOIN readings ON comments.id = readings.readable_id
       AND readings.readable_type = 'Comment'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL' }
  }

  named_scope :unread_by, lambda { |user|
     { :joins => "LEFT OUTER JOIN readings ON discussions.id = readings.readable_id
       AND readings.readable_type = 'Discussion'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL' }
  }

  private

  def notify_recipients
    for user in self.users
      UserMailer.deliver_discussion_notification(self, user)
    end
  end
end
