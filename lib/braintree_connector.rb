class BraintreeConnector

  attr_accessor :payer, :callback

  def initialize(payer, callback)
    @payer = payer
    @callback = callback
  end
  
  def payer_type
    if payer.is_a?(User) then "User" else "Restaurant" end
  end

  def braintree_customer_id
    "#{payer_type}_#{payer.id}"
  end

  def braintree_plan_id
    if payer_type == "User" then "user_monthly" else "restaurant_monthly" end
  end

  def braintree_contact_email
    if payer_type == "User" then payer.email else payer.manager.email end
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
            :email => braintree_contact_email,
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
          :email => braintree_contact_email,
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
      :plan_id => braintree_plan_id
    )
  end
  
  def self.cancel_subscription(subscription)
    Braintree::Subscription.cancel(subscription.braintree_id)
  end

  def cancel_subscription(subscription)
    BraintreeConnector.cancel_subscription(subscription)
  end
  
  def self.find_subscription(subscription)
    Braintree::Subscription.find(subscription.braintree_id)
  end
  
  def find_subscription(subscription)
    BraintreeConnector.find_subscription(subscription)
  end

end