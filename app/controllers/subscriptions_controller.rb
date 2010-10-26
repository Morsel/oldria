class SubscriptionsController < ApplicationController

  before_filter :init_braintree_customer
  before_filter :create_braintree_connector

  # API expects customer id (restaurant or user) as params[:customer_id] 
  # or params[:id], and either "restaurant" or "user" as params[:subscriber_type]

  def new
    @tr_data = @braintree_connector.braintree_data
  end

  def edit
    @tr_data = @braintree_connector.braintree_data
  end

  def bt_callback
    request_kind = request.params[:kind]
    bt_result = @braintree_connector.confirm_request_and_start_subscription(request)
    if bt_result.success?
      @braintree_customer.make_premium!(bt_result)
      flash[:success] = (request_kind == "update_customer")? "Thanks! Your payment information has been updated." : "Thanks for upgrading to Premium!"
      redirect_to customer_edit_redirect
    else
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided. If you continue to experience issues, please contact us."
      redirect_to(new_subscription_path(:customer_id => @braintree_customer.id,
          :subscriber_type => params[:subscriber_type]))
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
    redirect_to customer_edit_redirect
  end

  private

  def init_braintree_customer
    require_user
    @braintree_customer = if params[:subscriber_type] == "restaurant" 
                          then find_restaurant 
                          else find_user 
                          end
  end

  def find_user
    require_user
    if local_id.to_i == current_user.id
      return current_user
    elsif current_user.admin?
      return User.find(local_id)
    else
      redirect_to root_path
    end
  end
  
  # TODO: manager or admin only for restaurants
  def find_restaurant
    restaurant = Restaurant.find(local_id)
    if cannot? :edit, restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to restaurant
      return
    end
    restaurant
  end
  
  def local_id
    params[:customer_id] || params[:id]
  end

  def create_braintree_connector
    @braintree_connector = BraintreeConnector.new(@braintree_customer,
        bt_callback_subscriptions_url(:customer_id => @braintree_customer.id,
            :subscriber_type => params[:subscriber_type]))
  end
  
  def customer_edit_redirect
    if params[:subscriber_type] == "restaurant"
      edit_restaurant_path(@braintree_customer)
    else
      edit_user_path(@braintree_customer)
    end
  end

end
