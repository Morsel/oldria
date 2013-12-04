# == Schema Information
#
# Table name: direct_messages
#
#  id                     :integer         not null, primary key
#  body                   :text
#  sender_id              :integer         not null
#  receiver_id            :integer         not null
#  in_reply_to_message_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  from_admin             :boolean         default(FALSE)
#

class DirectMessage < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  belongs_to :sender, :class_name => "User"
  default_scope :order => "#{table_name}.created_at DESC"
  acts_as_readable
  attr_accessible :body, :sender_id, :receiver_id, :in_reply_to_message_id, :from_admin  

  has_many :responses, :class_name => "DirectMessage", :foreign_key => "in_reply_to_message_id", :order => "created_at"
  belongs_to :parent, :class_name => "DirectMessage", :foreign_key => "in_reply_to_message_id"

  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :attachments

  scope :all_from_admin, :conditions => { :from_admin => true }
  scope :all_not_from_admin, :conditions => { :from_admin => false }

  scope :root, :conditions => { :in_reply_to_message_id => nil }

  validates_presence_of :receiver
  validates_presence_of :sender
  validates_presence_of :body

  attr_protected :from_admin

  def self.title
    "Private Message"
  end

  def inbox_title
    self.class.title
  end

  def email_title
    inbox_title
  end

  def validate
    if sender_id == receiver_id
      errors.add :receiver, "You can't send yourself a message"
    end
  end

  def build_reply
    message = DirectMessage.new(
      :sender => self.receiver,
      :receiver => self.sender,
      :in_reply_to_message_id => self.id
    )
    message.attachments.build
    message
  end

  def parent_message
    DirectMessage.find(in_reply_to_message_id) if in_reply_to_message_id
  end

  def root_message
    message = self
    while message.parent_message
      message = message.parent_message
    end
    return message
  end

  def descendants
    self.responses.map {|child| child.descendants}.flatten + [self]
  end

  def descendants_size
    descendants.size - 1 # ignore self for the count
  end

  def from?(user)
    sender_id == user.id
  end

  ##
  # A generically-called public method that sets up and sends a
  # UserMailer notification based on the users' preferences.
  # Should only be called from an external observer.
  def notify_recipients
    if receiver.prefers_receive_email_notifications
      UserMailer.message_notification(self, receiver, sender).deliver
    end
  end

end


