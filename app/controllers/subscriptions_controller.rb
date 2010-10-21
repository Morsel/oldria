class SubscriptionsController < ApplicationController

  before_filter :create_braintree_connector

  def new
    @tr_data = @braintree_connector.braintree_data
  end

  def bt_callback
    bt_result = @braintree_connector.confirm_request_and_start_subscription(request)
    if bt_result.success?
      current_user.make_premium!(bt_result)
      redirect_to edit_user_path(current_user)
    else
      # ap bt_result
      # ap bt_result.params
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided. If you continue to experience issues, please contact us."
      # flash[:error] = bt_result.errors
      redirect_to(new_subscription_path)
    end
  end
  
  def destroy
    destroy_result = @braintree_connector.cancel_subscription(
        current_user.subscription)
    if destroy_result.success?
      current_user.cancel_subscription
    end
    redirect_to edit_user_path(current_user)
  end

  private

  def create_braintree_connector
    @braintree_connector = BraintreeConnector.new(current_user, 
        bt_callback_subscriptions_url)
  end

end
