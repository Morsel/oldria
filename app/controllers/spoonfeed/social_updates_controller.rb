class Spoonfeed::SocialUpdatesController < ApplicationController

  def index
    @alm_answers = ALaMinuteAnswer.from_premium_responders.all.map { |a| { :post => a.answer,
                                                                           :restaurant => a.restaurant,
                                                                           :created_at => a.created_at,
                                                                           :link => a_la_minute_answers_path(:question_id => a.a_la_minute_question.id),
                                                                           :title => a.question,
                                                                           :source => "Spoonfeed" } }

    @twitter_posts = []
    Restaurant.with_twitter.each do |r|
      begin
        r.twitter_client.home_timeline.each do |post|
          @twitter_posts << { :title => post.text,
                              :restaurant => r,
                              :created_at => Time.parse(post.created_at),
                              :link => "http://twitter.com/#{r.twitter_username}/status/#{post.id}",
                              :source => "Twitter" }
        end
      rescue
        next
      end
    end

    @facebook_posts = []
    Restaurant.with_facebook_page.each do |r|
      begin
        r.facebook_page.posts.each do |post|
          @facebook_posts << { :title => post.message,
                               :restaurant => r,
                               :created_at => Time.parse(post.created_time),
                               :source => "Facebook",
                               :link => r.facebook_page_url }
        end
      rescue
        next
      end
    end

    merger = SocialMerger.new(@twitter_posts, @facebook_posts, @alm_answers)
    @updates = merger.sorted_updates
  end

end
