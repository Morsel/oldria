class Soapbox::NewsletterSubscribersController < ApplicationController

  def create
    @subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])
    if @subscriber.save
      redirect_to :action => "welcome", :id => @subscriber.id
    else
      render :action => "new"
    end
  end

  def welcome
    @subscriber = NewsletterSubscriber.find(params[:id])
  end

  def confirm
    @subscriber = NewsletterSubscriber.find(params[:id])
    if params[:token] == @subscriber.confirmation_token
      @subscriber.confirm!
    else
      render :text => "Sorry, that link is not valid"
    end
  end

end
