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
    if @subscriber.update_attributes(params[:newsletter_subscriber])
      flash[:notice] = "Thanks! Your preferences have been updated."
      redirect_to_user_or_edit
    else
      @subscriber.user.present? ? redirect_to_user_or_edit : render(:action => "edit")
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
      flash[:error] = "You entered in an incorrect email address or password. Please try again."
      render :action => 'find_subscriber'
    end
  end

  private

  def verify_subscriber
    if current_user && current_user.newsletter_subscriber.present?
      @subscriber = current_user.newsletter_subscriber
    else
      @subscriber = NewsletterSubscriber.find(params[:id])
      redirect_to :action => "find_subscriber" unless cookies['newsletter_subscriber_id'] == @subscriber.id.to_s
    end
  end

  def redirect_to_user_or_edit
    redirect_to @subscriber.user.present? ? edit_newsletters_user_url(@subscriber.user) : { :action => "edit" }
  end

end
