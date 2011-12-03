class Soapbox::NewsletterSubscribersController < ApplicationController

  def create
    @subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])
    if @subscriber.save
      redirect_to :action => "first_confirmation", :id => @subscriber.id
    else
      render :action => "new"
    end
  end

  def first_confirmation
    @subscriber = NewsletterSubscriber.find(params[:id])
  end

end
