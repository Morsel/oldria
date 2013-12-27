class InvitedEmployee < ActiveRecord::Base
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email, :message => "That email address has already been invited"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true
  attr_accessible :first_name, :last_name,:email
end 

