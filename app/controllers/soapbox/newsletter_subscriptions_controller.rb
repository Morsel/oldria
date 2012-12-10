class Soapbox::NewsletterSubscriptionsController < ApplicationController

  def update
    @subscription = NewsletterSubscription.find(params[:id])
    @subscriber = @subscription.newsletter_subscriber
    @subscription.update_attributes(params[:newsletter_subscription])
    redirect_to_user_or_edit
  end

  def destroy
    @subscription = NewsletterSubscription.find(params[:id])
    @subscriber = @subscription.newsletter_subscriber
    if @subscription.destroy
      flash[:notice] = "You have successfully been unsubscribed."
      redirect_to_user_or_edit
    end
  end

  private

  def redirect_to_user_or_edit
    redirect_to @subscriber.user.present? ? edit_newsletters_user_url(@subscriber.user, :subdomain => 'spoonfeed') : edit_soapbox_newsletter_subscriber_path(@subscriber)
  end

end
