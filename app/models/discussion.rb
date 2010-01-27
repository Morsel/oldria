class Discussion < ActiveRecord::Base
  belongs_to :poster, :class_name => "User"
  has_many :discussion_seats
  has_many :users, :through => :discussion_seats

  after_create :notify_recipients

  private

  def notify_recipients
    for user in self.users
      UserMailer.deliver_discussion_notification(self, user)
    end
  end
end
