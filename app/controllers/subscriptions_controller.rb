 class SubscriptionsController < ApplicationController
  include SubscriptionsControllerHelper

  ssl_required :new, :edit if Rails.env.production?

  before_filter :require_user
  before_filter :find_customer
  before_filter :create_braintree_connector

  # API expects customer id (restaurant or user) as params[:customer_id]
  # or params[:id], and either "restaurant" or "user" as params[:subscriber_type]

  def new
    @tr_data = @braintree_connector.braintree_data
    @customer = Customer.new
    #session[:payment_decline] = "0" if session[:payment_decline].nil?
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
    bt_result = @braintree_connector.confirm_request_and_start_subscription(request, :apply_discount => billing_info_for_complimentary_payer?)
    if bt_result.success?
      UserMailer.deliver_log_file(params)
      if billing_info_for_complimentary_payer?
        @braintree_customer.update_complimentary_with_braintree_id!(bt_result.subscription.id)
      else
        if request_kind == 'update_customer'
          @braintree_customer.update_premium!(bt_result)
        else
          @braintree_customer.make_premium!(bt_result)
        end
      end
      @braintree_customer.update_attributes(:error_count=>0)
      flash[:success] = (request_kind == "update_customer")? "Thanks! Your payment information has been updated." : "Thanks for upgrading to Premium!"
      redirect_to customer_edit_path(@braintree_customer)
    else      
      if Delayed::Job.find(:all,:conditions=>["handler LIKE ?","%Restaurant:#{@braintree_customer.id}\nmethod: :send_user_alert_for_payment_declined%"]).blank?
        [0,10,20].each do |day|    
          @braintree_customer.send_at(day.days.from_now,:send_user_alert_for_payment_declined)
        end
      end      
      if session[:payment_decline] == "3" #TODU make account to basic if payement decline
        session.delete(:payment_decline)
        @braintree_customer.admin_cancel
      else 
        session[:payment_decline] = "#{(session[:payment_decline].to_i + 1)}"
      end
      if params[:restaurant_id].present?
        check_restaurant_counter 
      elsif  params[:user_id].present?
        check_user_counter
      end  
      check_error_count(bt_result)
      Rails.logger.info "[Braintree Error Message] #{bt_result.message}"
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided due to the following reason: <br /> #{bt_result.message} <br /> If you continue to experience issues, <a href='mailto:billing@restaurantintelligenceagency.com?subject=Payment issue!'>Please contact us.</a>"
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
      destroy_result = @braintree_connector.cancel_subscription(@braintree_customer.subscription)
      if destroy_result.success?
        @braintree_customer.cancel_subscription!(:terminate_immediately => false)
      else  
        flash[:error] = "#{destroy_result.message}"  
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

  def check_restaurant_counter
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.increment!(:error_count)   
    @value = get_counter_msg(@restaurant.error_count) 
  end 
  
  def check_user_counter
    @user = User.find(params[:user_id])
    @user.increment!(:error_count)   
    @value =get_counter_msg(@user.error_count)
  end 

  def check_error_count(bt_result)
    if @braintree_customer.error_count.present? && @braintree_customer.error_count > 2  
      @braintree_customer.admin_cancel
    elsif @braintree_customer.error_count.present? && @braintree_customer.error_count < 3  
      UserMailer.deliver_send_payment_error(@braintree_customer,bt_result.message,@value)
    end
  end   

end