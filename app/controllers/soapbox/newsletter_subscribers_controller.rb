class Soapbox::NewsletterSubscribersController < ApplicationController

  before_filter :verify_subscriber, :only => ['edit', 'update']

  def create
    @subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])
    if @subscriber.save
      redirect_to :action => "welcome", :id => @subscriber.id
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @subscriber = NewsletterSubscriber.find(params[:id])
    if @subscriber.update_attributes(params[:newsletter_subscriber])
      flash[:notice] = "Thanks! Your preferences have been updated."
      redirect_to :action => "edit"
    else
      render :action => "edit"
    end
  end

  def welcome
    @subscriber = NewsletterSubscriber.find(params[:id])
  end

  def confirm
    @subscriber = NewsletterSubscriber.find(params[:id])
    if params[:token] == @subscriber.confirmation_token
      @subscriber.confirm!
      cookies['newsletter_subscriber_id'] = @subscriber.id
    else
      render :text => "Sorry, that link is not valid"
    end
  end

  def find_subscriber
    @restaurant = Restaurant.find(params[:restaurant_id]) if params[:restaurant_id]
  end

  def connect
    @subscriber = NewsletterSubscriber.authenticate(params[:email], params[:password])
    if @subscriber.present?
      cookies['newsletter_subscriber_id'] = @subscriber.id
      if params[:restaurant_id]
        redirect_to subscribe_soapbox_restaurant_path(:id => params[:restaurant_id])
      else
        redirect_to :action => "edit", :id => @subscriber.id
      end
    else
      cookies.delete('newsletter_subscriber_id')
      flash[:notice] = "Please register as a diner in order to subscribe to restaurants."
      redirect_to join_path(:subdomain => "spoonfeed")
    end
  end

  private

  def verify_subscriber
    @subscriber = NewsletterSubscriber.find(params[:id])
    redirect_to :action => "find_subscriber" unless cookies['newsletter_subscriber_id'] == @subscriber.id.to_s
  end

end
