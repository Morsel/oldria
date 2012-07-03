class SocialPost < ActiveRecord::Base
  belongs_to :restaurant


  def self.secheduler
    print "Hi"
  end

end

