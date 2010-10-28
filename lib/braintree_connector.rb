class BraintreeConnector
  
  PLANS = {"User" => "user_monthly", "Restaurant" => "restaurant_monthly"}
  ADD_ON = "user_for_restaurant"
  DISCOUNT_ID = "complimentary_restaurant"

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
    PLANS[payer_type]
    #if payer_type == "User" then "user_monthly" else "restaurant_monthly" end
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

  def confirm_request_and_start_subscription(request, options = {})
    @confirmation_result = confirm_request(request)
    return @confirmation_result unless @confirmation_result.success?
    @subscription_request ||= (payer.has_braintree_account?) ? update_subscription : create_subscription(options)
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

  def self.past_due_subscriptions
    result = Braintree::Subscription.search do |search|
      search.days_past_due <= 5
    end
    result.ids
  end
  
  # code assumes that a quantity of one implies an add, any other quantity implies
  # an update
  def self.set_add_ons_for_subscription(subscription, quantity)
    if quantity == 1
      Braintree::Subscription.update(subscription.braintree_id, 
        :add_ons => {:add => [{:inherited_from_id => ADD_ON, :quantity => quantity}]})
    else
      Braintree::Subscription.update(subscription.braintree_id, 
        :add_ons => {:update => [{:existing_id => ADD_ON, :quantity => quantity}]})
    end
  end

  def transaction_history
    results = Braintree::Transaction.search do |search|
      search.customer_id.is braintree_customer_id
    end
  end

  private
  def update_subscription
    Braintree::Subscription.update(payer.subscription.braintree_id,
      :payment_method_token => @confirmation_result.customer.credit_cards.first.token
    )
  end

  def create_subscription(options = {})
    create_options = {
        :payment_method_token => @confirmation_result.customer.credit_cards.first.token,
        :plan_id => braintree_plan_id}
    if options[:apply_discount]
      create_options[:discounts] = {:add => [{:inherited_from_id => DISCOUNT_ID}]}
    end
    Braintree::Subscription.create(create_options)
  end

end