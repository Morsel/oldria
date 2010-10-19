class SubscriptionsController < ApplicationController
  
  def new
    @customer = find_braintree_customer
    @tr_data = braintree_data
  end
  
  def bt_callback
    @result = confirm_braintree_request
    if @result.success?
      @subscription_result = make_subscription_request
      if @subscription_result.success?
        current_user.update_attributes(:premium_account => true)
      end
    end
    if @result.success? && @subscription_result.success?
      redirect_to edit_user_path(current_user)
    else
      redirect_to(new_subscription_path)
    end
  end
  
  private
  
  def braintree_customer_id
    "User_#{current_user.id}"
  end
  
  def find_braintree_customer
    Braintree::Customer.find(braintree_customer_id) rescue nil
  end
  
  def braintree_data
    if @customer
      Braintree::TransparentRedirect.update_customer_data(
        :redirect_url => bt_callback_subscriptions_url,
        :customer_id => braintree_customer_id, 
        :customer => {
            :credit_card => {
              :options => {
                :update_existing_token => customer.credit_cards.first.token
              }
            }
          }
      )
    else
      Braintree::TransparentRedirect.create_customer_data(
        :redirect_url => bt_callback_subscriptions_url,
        :customer => {
          :id => braintree_customer_id
        }
      )
    end
  end
  
  def confirm_braintree_request
    Braintree::TransparentRedirect.confirm(request.query_string)
  end
  
  def make_subscription_request
    Braintree::Subscription.create(
      :payment_method_token => @result.customer.credit_cards.first.token,
      :plan_id => "kpw2"
    )
  end
  
end
