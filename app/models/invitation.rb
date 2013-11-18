# == Schema Information
#
# Table name: invitations
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  title              :string(255)
#  coworker           :boolean         default(FALSE)
#  restaurant_id      :integer
#  restaurant_name    :string(255)
#  requesting_user_id :integer
#  invitee_id         :integer
#  approved_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  archived           :boolean         default(FALSE)
#  restaurant_role_id :integer
#

class Invitation < ActiveRecord::Base
  
  belongs_to :requesting_user, :class_name => "User"
  belongs_to :invitee, :class_name => "User"
  belongs_to :restaurant
  belongs_to :restaurant_role

  has_many :invite_responsibilities, :dependent => :destroy
  has_many :subject_matters, :through => :invite_responsibilities
  
  validates_presence_of :email, :first_name, :last_name, :restaurant_role, :restaurant_name, :subject_matters
  validates_uniqueness_of :email, :message => "That email address has already been invited"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true
  
  after_create :send_welcome_and_notify_admins
  attr_accessible :first_name, :last_name, :email, :restaurant_role_id, :restaurant_name, :subject_matters,:subject_matter_ids
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def username
    first_name.downcase + last_name.downcase
  end
  
  def send_welcome_and_notify_admins
    UserMailer.invitation_welcome(self).deliver unless requesting_user_id
    UserMailer.admin_invitation_notice(self).deliver
  end

  def self.build_from_registration(params)
    new(:first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email],
        :restaurant_role_id => params[:restaurant_role],
        :restaurant_name => params[:restaurant_name],
        :subject_matters => SubjectMatter.find(:all,:conditions=>["id in (?)",params[:subject_matters].try(:keys)]))
  end

end

