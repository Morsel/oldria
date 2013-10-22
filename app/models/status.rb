# == Schema Information
#
# Table name: statuses
#
#  id                      :integer         not null, primary key
#  message                 :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  user_id                 :integer
#  twitter_id              :integer
#  queue_for_social_media  :boolean
#  queue_for_facebook      :boolean
#  facebook_id             :integer
#  queue_for_facebook_page :boolean         default(FALSE)
#  facebook_page_id        :integer
#

class Status < ActiveRecord::Base
  belongs_to :user
  default_scope :order => "created_at DESC"
  include ActionView::Helpers

  scope :friends_of_user, lambda { |user| {:conditions => { :user_id => user.friend_ids }} } 

  before_validation :strip_html
  after_create      :send_to_social_media!

  def strip_html
    self.message = strip_tags(message)
  end
  
  def send_to_social_media!
    if queue_for_social_media
      response = user.twitter_client.update(self.message)
      if response && response['id']
        update_attributes!(:twitter_id => response['id'].to_i, :queue_for_social_media => nil)
      end
    end

    if queue_for_facebook
      response = user.facebook_user.feed_create(Mogli::Post.new(:message => self.message))
      if response && response['id']
        update_attributes!(:facebook_id => response['id'].to_i, :queue_for_facebook => nil)
      end
    end
    
    if queue_for_facebook_page
      response = user.facebook_page.feed_create(Mogli::Post.new(:message => self.message))
      if response && response['id']
        update_attributes!(:facebook_page_id => response['id'].to_i, :queue_for_facebook => nil)
      end
    end
  end
  
end


