module Soapbox
  class RestaurantsController < ApplicationController

    def show
      @restaurant = Restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_root_path)
        return
      end

      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
      @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 3)
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    end

    def subscribe
      subscriber = NewsletterSubscriber.find(cookies['newsletter_subscriber_id'])
      restaurant = Restaurant.find(params[:id])
      NewsletterSubscription.find_or_create_by_restaurant_id_and_newsletter_subscriber_id(:newsletter_subscriber => subscriber, :restaurant => restaurant)
      flash[:notice] = "#{subscriber.email} is now subscribed to #{restaurant.name}'s newsletter."
      redirect_to :action => "confirm_subscription", :subscriber_id => subscriber.id
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Please register as a diner in order to subscribe to restaurants."
      redirect_to join_path
    end

    def confirm_subscription
      @subscriber = NewsletterSubscriber.find(params[:subscriber_id])
      @restaurant = Restaurant.find(params[:id])
      @subscription = NewsletterSubscription.find_by_restaurant_id_and_newsletter_subscriber_id(@restaurant.id, @subscriber.id)
    end

  end
end
