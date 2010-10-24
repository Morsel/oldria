class SubscriptionsController < ApplicationController

  before_filter :init_user
  before_filter :create_braintree_connector

  # note: all of these calls require a user id as params[:id], even the
  # ones that traditionally wouldn't in a RESTful service

  def new
    @tr_data = @braintree_connector.braintree_data
  end

  def bt_callback
    bt_result = @braintree_connector.confirm_request_and_start_subscription(request)
    if bt_result.success?
      current_user.make_premium!(bt_result)
      redirect_to edit_user_path(@user)
    else
      # ap bt_result
      # ap bt_result.params
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided. If you continue to experience issues, please contact us."
      # flash[:error] = bt_result.errors
      redirect_to(new_subscription_path(:id => @user.id))
    end
  end

  def destroy
    destroy_result = @braintree_connector.cancel_subscription(
        @user.subscription)
    if destroy_result.success?
      @user.cancel_subscription!(:terminate_immediately => false)
    end
    redirect_to edit_user_path(@user)
  end

  private

  def init_user
    require_user
    local_id = params[:local_user_id] || params[:id]
    if local_id.to_i == current_user.id
      @user = current_user
      return
    end
    # if current_user.admin?
    #   @user = User.find(params[:user_id])
    # else
    #  @user = current_user
    # end
  end

  def create_braintree_connector
    @braintree_connector = BraintreeConnector.new(@user,
        bt_callback_subscriptions_url(:local_user_id => @user.id))
  end

end
