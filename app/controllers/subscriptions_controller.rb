class SubscriptionsController < ApplicationController
  
  def new
    customer = Braintree::Customer.find("User_#{current_user.id}") rescue nil
    if customer
      @tr_data =  Braintree::TransparentRedirect.update_customer_data(
        :redirect_url => bt_callback_subscriptions_url,
        :customer_id => "User_#{current_user.id}", 
        :customer => {
            :credit_card => {
              :options => {
                :update_existing_token => customer.credit_cards.first.token
              }
            }
          }
      )
    else
      @tr_data = Braintree::TransparentRedirect.create_customer_data(
        :redirect_url => bt_callback_subscriptions_url,
        :customer => {
          :id => "User_#{current_user.id}"
        }
      )
    end
  end
  
  def bt_callback
    result = Braintree::TransparentRedirect.confirm(request.query_string)
    if result.success?
      subscription_result = Braintree::Subscription.create(
        :payment_method_token => result.customer.credit_cards.first.token,
        :plan_id => "kpw2"
      )
      if subscription_result.success?
        # our stuff
      end
    end
    # ap subscription_result.subscription.next_billing_date
    redirect_to edit_user_path(current_user)
  end
  
end
