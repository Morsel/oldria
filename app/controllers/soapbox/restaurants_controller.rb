module Soapbox
  class RestaurantsController < ApplicationController
    def show      
      @soapbox_restaurant_id =  params[:id]
      @soapbox_keywordable_type = 'Restaurant' 
      trace_keyword
      @restaurant = Restaurant.activated_restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_root_path)
        return
      end

      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
      @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 3)
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
      @subscriber = current_subscriber
    end

    def subscribe
      subscriber = current_subscriber(true)
      restaurant = Restaurant.find(params[:id])

      if subscriber.present?
        if NewsletterSubscription.create(:newsletter_subscriber => subscriber, :restaurant => restaurant)
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

    def trace_keyword
    @restaurant = Restaurant.find(params[:id])
      url = request.url
      keywordable_id = @restaurant.id
      keywordable_type = 'restaurant'
      title = @restaurant.name
    unless current_user.blank?
      @trace_soapbox_keyword = SoapboxTraceKeyword.find_by_keywordable_id_and_keywordable_type_and_url_and_title_and_restaurant_id_and_user_id(keywordable_id, keywordable_type,url,title,@restaurant.id,current_user.id)     
      @trace_soapbox_keyword = @trace_soapbox_keyword.nil? ? SoapboxTraceKeyword.create(:keywordable_id => keywordable_id,:keywordable_type => keywordable_type,:user_id=> current_user.id,:url=> url,:title=> title,:restaurant_id=>@restaurant.id) : @trace_soapbox_keyword.increment!(:count)  
    end
  end
end
end
