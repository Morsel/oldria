class SubscriptionsController < ApplicationController
  include SubscriptionsControllerHelper

  ssl_required :new, :edit if Rails.env.production?

  before_filter :find_customer
  before_filter :create_braintree_connector

  # API expects customer id (restaurant or user) as params[:customer_id]
  # or params[:id], and either "restaurant" or "user" as params[:subscriber_type]

  def new
    @tr_data = @braintree_connector.braintree_data
    @customer = Customer.new
  end

  def edit
    bt_customer = @braintree_connector.braintree_customer

    @customer = Customer.new
    credit_card = bt_customer.credit_cards.first
    @customer.credit_card.number = "#{'*'*12}#{credit_card.last_4}"
    @customer.credit_card.expiration_month = credit_card.expiration_month
    @customer.credit_card.expiration_year = credit_card.expiration_year
    @customer.credit_card.billing_address.postal_code = credit_card.billing_address.postal_code

    @tr_data = @braintree_connector.braintree_data
  end

  def bt_callback
    request_kind = request.params[:kind]
    bt_result = @braintree_connector.confirm_request_and_start_subscription(
        request, :apply_discount => billing_info_for_complimentary_payer?)
    if bt_result.success?
      if billing_info_for_complimentary_payer?
        @braintree_customer.update_complimentary_with_braintree_id!(bt_result.subscription.id)
      else
        if request_kind == 'update_customer'
          @braintree_customer.update_premium!(bt_result)
        else
          @braintree_customer.make_premium!(bt_result)
        end
      end

      flash[:success] = (request_kind == "update_customer")? "Thanks! Your payment information has been updated." : "Thanks for upgrading to Premium!"
      redirect_to customer_edit_path(@braintree_customer)
    else
      Rails.logger.info "[Braintree Error Message] #{bt_result.message}"
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided. If you continue to experience issues, please contact us."
      if request_kind == 'update_customer'
        redirect_to(edit_subscription_path(@braintree_customer))
      else
        redirect_to(new_subscription_path(@braintree_customer))
      end
    end
  end

  def destroy
    if @braintree_customer.complimentary_account?
      @braintree_customer.cancel_subscription!(:terminate_immediately => false)
    else
      destroy_result = @braintree_connector.cancel_subscription(
          @braintree_customer.subscription)
      if destroy_result.success?
        @braintree_customer.cancel_subscription!(:terminate_immediately => false)
      end
    end
    redirect_to customer_edit_path(@braintree_customer)
  end

  def billing_history
    @transactions = @braintree_connector.transaction_history
  end

  private

  def billing_info_for_complimentary_payer?
    @braintree_customer.can_be_payer? && @braintree_customer.complimentary_account?
  end

  def find_customer
    require_user
    @braintree_customer = if params[:user_id]
      find_user(params[:user_id])
    elsif params
      find_restaurant(params[:restaurant_id])
    end
  end

  def find_user(local_id)
    if local_id.to_i == current_user.id
      return current_user
    elsif current_user.admin?
      return User.find(local_id)
    else
      redirect_to root_path
    end
  end

  def find_restaurant(local_id)
    restaurant = Restaurant.find(local_id)
    if cannot? :edit, restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to restaurant
      return
    end
    restaurant
  end

  def create_braintree_connector
    @braintree_connector = BraintreeConnector.new(@braintree_customer,
        bt_callback_subscription_url(@braintree_customer))
  end
end
