class Soapbox::NewsletterSubscriptionsController < ApplicationController

  def update
    @subscription = NewsletterSubscription.find(params[:id])
    @subscriber = @subscription.newsletter_subscriber
    @subscription.update_attributes(params[:newsletter_subscription])
    redirect_to edit_soapbox_newsletter_subscriber_path(@subscriber)
  end

  def destroy
    @subscription = NewsletterSubscription.find(params[:id])
    @subscriber = @subscription.newsletter_subscriber
    if @subscription.destroy
      flash[:notice] = "You have successfully been unsubscribed."
      redirect_to edit_soapbox_newsletter_subscriber_path(@subscriber)
    end
  end

end
