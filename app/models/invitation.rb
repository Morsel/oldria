# == Schema Information
# Schema version: 20100921161540
#
# Table name: invitations
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  title              :string(255)
#  coworker           :boolean
#  restaurant_id      :integer
#  restaurant_name    :string(255)
#  requesting_user_id :integer
#  invitee_id         :integer
#  approved_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  archived           :boolean
#

class Invitation < ActiveRecord::Base
  
  belongs_to :requesting_user, :class_name => "User"
  belongs_to :invitee, :class_name => "User"
  belongs_to :restaurant
  
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email, :message => "That person has already been invited"
  
  after_create :send_welcome
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def username
    first_name.downcase + last_name.downcase
  end
  
  def send_welcome
    UserMailer.deliver_invitation_welcome(self) unless requesting_user_id
  end

end
