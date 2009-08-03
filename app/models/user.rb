class User < ActiveRecord::Base
  acts_as_authentic
  
  def confirmed?
    confirmed_at
  end
  
end
