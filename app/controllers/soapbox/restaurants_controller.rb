module Soapbox
  class RestaurantsController < ApplicationController
    def show      
      @soapbox_restaurant_id =  params[:id]
      @soapbox_keywordable_type = 'Restaurant' 
      @restaurant = Restaurant.activated_restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_root_path)
        return
      end
      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
      @promotions = @restaurant.promotions.find(:all, :order => "created_at desc", :limit => 3)  
      @menu_items = @restaurant.menu_items.find(:all, :order => "created_at desc", :limit => 3)  
      @subscriber = current_subscriber
    end

    def subscribe
      subscriber = current_subscriber(true)
      restaurant = Restaurant.find(params[:id])

      if subscriber.present?
        newsletter_subscriber = NewsletterSubscription.new
        newsletter_subscriber.newsletter_subscriber_id = subscriber.id
        newsletter_subscriber.restaurant_id = restaurant.id
        if newsletter_subscriber.save#NewsletterSubscription.create(:newsletter_subscriber => subscriber, :restaurant => restaurant)
          flash[:notice] = "#{subscriber.email} is now subscribed to #{restaurant.name}'s newsletter."
          redirect_to :action => "confirm_subscription", :subscriber_id => subscriber.id
        else
          redirect_to :action => "show", :id => restaurant.id
        end
      else
        redirect_to find_subscriber_soapbox_newsletter_subscribers_path(:restaurant_id => params[:id])
      end
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
