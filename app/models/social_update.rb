# == Schema Information
#
# Table name: social_updates
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
#  post_id         :string(255)
#

class SocialUpdate < ActiveRecord::Base
  belongs_to :restaurant
  attr_accessible :post_data, :post_id, :restaurant, :post_created_at, :link, :title, :source,:restaurant_id

  def self.fetch_updates
    alm_answers = ALaMinuteAnswer.social_results({})

    twitter_posts = []
    Restaurant.with_premium_account.with_twitter.all.each do |r|
      begin
        r.twitter_client.user_timeline.each do |post|
          twitter_posts << { :post_id => post.id,
                             :post_data => post.text,
                             :restaurant => r,
                             :post_created_at => Time.parse(post.created_at),
                             :link => "http://twitter.com/#{r.twitter_username}/status/#{post.id}",
                             :source => "Twitter" }
        end
      rescue Exception
        next
      end
    end

    facebook_posts = []
    Restaurant.with_premium_account.with_facebook_page.all.each do |r|
      begin
        r.facebook_page.posts.each do |post|
          facebook_posts << { :post_id => post.id,
                              :post_data => post.message,
                              :restaurant => r,
                              :post_created_at => Time.parse(post.created_time),
                              :source => "Facebook",
                              :link => r.facebook_page_url }
        end
      rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException,Exception
        next
      end
    end
    updates = (twitter_posts + facebook_posts + alm_answers)
    
    for update in updates
      post = SocialUpdate.find_or_create_by_post_id_and_source(:post_id => update[:post_id], :source => update[:source])
      post.update_attributes(update)
    end
  end

end
