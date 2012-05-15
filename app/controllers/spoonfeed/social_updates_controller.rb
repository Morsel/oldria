class Spoonfeed::SocialUpdatesController < ApplicationController

  before_filter :require_user

  def index
  end

  def load_updates
    sorted_merge = fetch_updates

    @updates = sorted_merge.paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  private

  def fetch_updates
    Rails.cache.fetch('social_updates') do
      alm_answers = ALaMinuteAnswer.from_premium_responders.all.map { |a| { :post => a.answer,
                                                                             :restaurant => a.restaurant,
                                                                             :created_at => a.created_at,
                                                                             :link => a_la_minute_answers_path(:question_id => a.a_la_minute_question.id),
                                                                             :title => a.question,
                                                                             :source => "Spoonfeed" } }

      twitter_posts = []
      Restaurant.with_twitter.each do |r|
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
      Restaurant.with_facebook_page.each do |r|
        begin
          r.facebook_page.posts.each do |post|
            facebook_posts << { :post => post.message,
                                 :restaurant => r,
                                 :created_at => Time.parse(post.created_time),
                                 :source => "Facebook",
                                 :link => r.facebook_page_url }
          end
        rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException
          next
        end
      end
      SocialMerger.new(twitter_posts, facebook_posts, alm_answers).sorted_updates
    end
  end

end
