class Spoonfeed::SocialUpdatesController < ApplicationController

  before_filter :require_user

  def index
  end

  def load_updates
    sorted_merge = fetch_updates

    @updates = sorted_merge.paginate(:page => params[:page], :per_page => 10)
    render :partial => "updates"
  end

  # def filter
  #   sorted_merge = fetch_updates(params[:search])
  # 
  #   @updates = sorted_merge.paginate(:page => params[:page], :per_page => 10)
  #   render :partial => "updates"
  # end

  private

  def fetch_updates
    Rails.cache.fetch("social_updates", :expires_in => 1.minute) do
      alm_answers = ALaMinuteAnswer.from_premium_responders.map { |a| { :post => a.answer,
                                                    :restaurant => a.restaurant,
                                                    :created_at => a.created_at,
                                                    :link => a_la_minute_answers_path(:question_id => a.a_la_minute_question.id),
                                                    :title => a.question,
                                                    :source => "Spoonfeed" } }

      twitter_posts = []
      Restaurant.with_premium_account.with_twitter.each do |r|
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

      SocialMerger.new(twitter_posts, facebook_posts, alm_answers).sorted_updates[0...1000] # limited so the results will fit in the cache
    end
  end

end
