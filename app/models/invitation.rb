# == Schema Information
# Schema version: 20100920193024
#
# Table name: invitations
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  coworker           :boolean
#  restaurant_id      :integer
#  requesting_user_id :integer
#  invitee_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Invitation < ActiveRecord::Base
  
  belongs_to :requesting_user, :class_name => "User"
  belongs_to :invitee, :class_name => "User"
  belongs_to :restaurant
  
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email, :message => "That person has already been invited"

end
