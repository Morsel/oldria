class Spoonfeed::SocialUpdatesController < ApplicationController

  #before_filter :require_user

  def index
  end

  def load_updates
    #save_post
    @updates = SocialPost.all.paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  def filter_updates
   # save_post
   #debugger
    #@updates = SocialPost.all.paginate(:page => params[:page], :per_page => 10)
    @updates = SocialPost.find(:all, :conditions => ["restaurant_id in (?) ", Restaurant.with_premium_account.with_twitter.search(params[:search]).all.collect(&:id)]).paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  def save_post

    sorted_merge = fetch_updates
    SocialPost.delete_all(["restaurant_id in (?) ", Restaurant.with_premium_account.collect(&:id)])
    sorted_merge.each do |post|
      SocialPost.create(:post_data => post[:post], :title => post[:title], :link => post[:link], :source => post[:source], :restaurant_id => post[:restaurant].id, :post_created_at => post[:created_at])
    end

    render :text => "Import social posts successfully!"

  end

  private

  def fetch_updates(search_params = {})
    # Rails.cache.fetch("social_updates_#{search_params.to_s}", :expires_in => 1.minute) do

      alm_answers = ALaMinuteAnswer.social_results(search_params)

      twitter_posts = []
      facebook_posts = []
      Restaurant.with_premium_account.with_twitter.search(search_params).all.each do |r|
        begin
          r.twitter_client.user_timeline.each do |post|
            twitter_posts << { :post => post.text,
                               :restaurant => r,
                               :created_at => Time.parse(post.created_at),
                               :link => "http://twitter.com/#{r.twitter_username}/status/#{post.id}",
                               :source => "Twitter" }
          end

          r.facebook_page.posts.each do |post|
               if !post.message.nil? && !post.message.blank?
                 facebook_posts << {:post => post.message,
                               :restaurant => r,
                               :created_at => Time.parse(post.created_time),
                               :link => "#",
                               :source => "Facebook"}
               end

          end
        rescue Exception
          next
        end
      end
      return SocialMerger.new(twitter_posts, facebook_posts, alm_answers).sorted_updates[0...1000] # limited so the results will fit in the cache
  end

end

