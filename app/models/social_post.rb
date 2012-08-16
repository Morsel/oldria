# == Schema Information
#
# Table name: social_posts
#
#  id              :integer         not null, primary key
#  post_data       :string(255)
#  link            :string(255)
#  post_created_at :datetime
#  source          :string(255)
#  restaurant_id   :integer
#  title           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class SocialPost < ActiveRecord::Base
  belongs_to :restaurant


  def self.secheduler
    print "Hi"
  end

end

