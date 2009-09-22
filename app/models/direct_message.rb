class DirectMessage < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"
  
  validates_presence_of :receiver
  validates_presence_of :sender
  
  def validate
    if sender_id == receiver_id
      errors.add :receiver, "You can't send yourself a message"
    end
  end
  
  def build_reply
    DirectMessage.new(
      :sender => self.receiver,
      :receiver => self.sender,
      :in_reply_to_message_id => self.id
    )
  end
  
  def parent_message
    DirectMessage.find(in_reply_to_message_id) if in_reply_to_message_id
  end
end
