class Spoonfeed::SocialUpdatesController < ApplicationController

  before_filter :require_user

  def index
  end

  def load_updates
    sorted_merge = fetch_updates

    @updates = sorted_merge.paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  def filter
    sorted_merge = fetch_updates(params[:search])

    @updates = sorted_merge.paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  private

  def fetch_updates(search_params = {})
    Rails.cache.fetch("social_updates_#{search_params.to_s}", :expires_in => 1.hour) do
      alm_answers = ALaMinuteAnswer.social_results(search_params)

      twitter_posts = []
      Restaurant.with_premium_account.with_twitter.search(search_params).all.each do |r|
        begin
          r.twitter_client.user_timeline.each do |post|
            twitter_posts << { :post => post.text,
                               :restaurant => r,
                               :created_at => Time.parse(post.created_at),
                               :link => "http://twitter.com/#{r.twitter_username}/status/#{post.id}",
                               :source => "Twitter" }
          end
        rescue Exception
          next
        end
      end

      facebook_posts = []
      # Restaurant.with_premium_account.with_facebook_page.search(search_params).all.each do |r|
      #   begin
      #     r.facebook_page.posts.each do |post|
      #       facebook_posts << { :post => post.message,
      #                           :restaurant => r,
      #                           :created_at => Time.parse(post.created_time),
      #                           :source => "Facebook",
      #                           :link => r.facebook_page_url }
      #     end
      #   rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException
      #     next
      #   end
      # end

      SocialMerger.new(twitter_posts, facebook_posts, alm_answers).sorted_updates[0...1000] # limited so the results will fit in the cache
    end
  end

end
