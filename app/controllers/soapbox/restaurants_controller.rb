module Soapbox
  class RestaurantsController < ApplicationController
    def show      
      @restaurant = Restaurant.activated_restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_root_path)
        return
      end

      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
      @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 3)
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
      @subscriber = NewsletterSubscriber.find(cookies['newsletter_subscriber_id']) if cookies.has_key?('newsletter_subscriber_id')
    end

    def subscribe
      subscriber = NewsletterSubscriber.find(cookies['newsletter_subscriber_id'])
      restaurant = Restaurant.find(params[:id])
      if NewsletterSubscription.create(:newsletter_subscriber => subscriber, :restaurant => restaurant)
        flash[:notice] = "#{subscriber.email} is now subscribed to #{restaurant.name}'s newsletter."
        redirect_to :action => "confirm_subscription", :subscriber_id => subscriber.id
      else
        redirect_to :action => "show", :id => restaurant.id
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to find_subscriber_soapbox_newsletter_subscribers_path(:restaurant_id => params[:id])
    end

    def confirm_subscription
      @subscriber = NewsletterSubscriber.find(params[:subscriber_id])
      @restaurant = Restaurant.find(params[:id])
      @subscription = NewsletterSubscription.find_by_restaurant_id_and_newsletter_subscriber_id(@restaurant.id, @subscriber.id)
    end

    def unsubscribe
      subscriber = NewsletterSubscriber.find(params[:subscriber_id])
      restaurant = Restaurant.find(params[:id])
      subscription = NewsletterSubscription.find_by_restaurant_id_and_newsletter_subscriber_id(restaurant.id, subscriber.id)
      if subscription.destroy
        flash[:notice] = "#{subscriber.email} is no longer subscribed to #{restaurant.name}'s newsletter."
        redirect_to edit_soapbox_newsletter_subscriber_path(subscriber)
      end
    end

  end
end
