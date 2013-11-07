class BraintreeConnector

  PLANS = {"User" => "user_monthly", "Restaurant" => "restaurant_monthly"}
  ADD_ON = "user_for_restaurant"
  DISCOUNT_ID = "complimentary_restaurant"

  attr_accessor :payer, :callback

  def initialize(payer, callback)
    raise NotImplementedError.new("#braintree_contact") unless payer.respond_to?(:braintree_contact)
    @payer = payer
    @callback = callback
  end

  def payer_type
    if payer.is_a?(User) then "User" else "Restaurant" end
  end

  def braintree_customer_id
    self.class.braintree_customer_id(payer)
  end

  def self.braintree_customer_id(payer)
    [braintree_prefix, payer.braintree_customer_id].join "_"
  end

  def self.braintree_prefix
    prefixes = []
    prefixes << Rails.env unless Rails.env.production?
    # prefixes << Rails.root.to_s.split("/")[4] if Rails.env.staging?
    prefixes.join "_"
  end

  def braintree_plan_id
    PLANS[payer_type]
    #if payer_type == "User" then "user_monthly" else "restaurant_monthly" end
  end

  def braintree_customer
    @customer ||= begin
      Braintree::Customer.find(braintree_customer_id) rescue nil
    end
  end

  def self.update_customer(payer)
    Rails.logger.info "Updating customer \"#{payer.braintree_customer_id}\" with #{braintree_customer_params(payer).inspect}"
    result = Braintree::Customer.update(self.braintree_customer_id(payer),
      braintree_customer_params(payer))
  end

  def braintree_data
    tr_params = {:customer => braintree_customer_params}.deep_merge({
        :redirect_url => callback,
        :customer => {
          :credit_card => {
            :options => { :verify_card => true }
          }
        }
      })

    if braintree_customer
      update_params = tr_params.deep_merge({
        :customer_id => braintree_customer_id,
        :customer => {
          :credit_card => {
            :options => {
              :update_existing_token => braintree_customer.credit_cards.first.token
            }
          }
        }
      })
      Braintree::TransparentRedirect.update_customer_data(update_params)
    else
      create_params = tr_params.deep_merge({
        :customer => { :id => braintree_customer_id }
      })
      Braintree::TransparentRedirect.create_customer_data(create_params)
    end
  end

  def braintree_customer_params
    BraintreeConnector.braintree_customer_params(payer)
  end

  def self.braintree_customer_params(payer)
    params = {
      :email => payer.braintree_contact.email,
      :last_name => payer.braintree_contact.last_name,
      :first_name => payer.braintree_contact.first_name,
      :company => (payer.is_a? Restaurant) ? payer.name : "NA" }
    params
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
    result.instance_values["ids"]
  end

  # TODO: possible refactor because quantity is redundent with
  # user_subscriptions_for_payer
  def self.set_add_ons_for_subscription(subscription, quantity)
    if quantity == 0
      Braintree::Subscription.update(subscription.braintree_id,
        :add_ons => {:remove => [ADD_ON]})
    elsif subscription.user_subscriptions_for_payer.size == 0
      Braintree::Subscription.update(subscription.braintree_id,
        :add_ons => {:add => [{:inherited_from_id => ADD_ON, :quantity => quantity}]})
    else
      Braintree::Subscription.update(subscription.braintree_id,
        :add_ons => {:update => [{:existing_id => ADD_ON, :quantity => quantity}]})
    end
  end

  def self.update_subscription_with_discount(subscription)
    Braintree::Subscription.update(subscription.braintree_id,
      :discounts => {:add => [{:inherited_from_id => DISCOUNT_ID}]})
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