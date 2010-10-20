class BraintreeConnector

  attr_accessor :user, :callback

  def initialize(user, callback)
    @user = user
    @callback = callback
  end

  def braintree_customer_id
    "User_#{user.id}"
  end

  def braintree_customer
    @customer ||= begin
      Braintree::Customer.find(braintree_customer_id) rescue nil
    end
  end

  def braintree_data
    if braintree_customer
      Braintree::TransparentRedirect.update_customer_data(
        :redirect_url => callback,
        :customer_id => braintree_customer_id,
        :customer => {
            :credit_card => {
              :options => {
                :update_existing_token => braintree_customer.credit_cards.first.token,
                :verify_card => true
              }
            }
          }
      )
    else
      Braintree::TransparentRedirect.create_customer_data(
        :redirect_url => callback,
        :customer => {
          :id => braintree_customer_id,
          :credit_card => {
            :options => {
              :verify_card => true
            }
          }
        }
      )
    end
  end

  def confirm_request(request)
    Braintree::TransparentRedirect.confirm(request.query_string)
  end

  def confirm_request_and_start_subscription(request)
    confirmation_result = self.confirm_request(request)
    return confirmation_result unless confirmation_result.success?
    @subscription_request ||= Braintree::Subscription.create(
      :payment_method_token => confirmation_result.customer.credit_cards.first.token,
      :plan_id => "user_monthly"
    )
  end
  
  def cancel_subscription(subscription)
    Braintree::Subscription.cancel(subscription.braintree_id)
  end

end