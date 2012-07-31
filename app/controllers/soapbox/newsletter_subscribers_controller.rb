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

  private

  def verify_subscriber
    @subscriber = NewsletterSubscriber.find(params[:id])
    redirect_to soapbox_root_path unless cookies['newsletter_subscriber_id'] == @subscriber.id.to_s
  end

end
