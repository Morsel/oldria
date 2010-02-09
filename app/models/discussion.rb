class Discussion < ActiveRecord::Base
  acts_as_commentable
  accepts_nested_attributes_for :comments

  belongs_to :poster, :class_name => "User"
  has_many :discussion_seats, :dependent => :destroy
  has_many :users, :through => :discussion_seats, :uniq => true

  validates_presence_of :title

  after_create :notify_recipients

  def posted_comments
    comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
  end

  private

  def notify_recipients
    for user in self.users
      UserMailer.deliver_discussion_notification(self, user)
    end
  end
end
