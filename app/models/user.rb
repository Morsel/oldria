class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :statuses
  
  def confirmed?
    confirmed_at
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self)  
  end
  
end
