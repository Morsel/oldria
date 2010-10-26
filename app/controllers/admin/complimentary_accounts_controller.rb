class Admin::ComplimentaryAccountsController < Admin::AdminController
  
  before_filter :find_subscriber
  
  def create
    proceed = cancel_braintree_subscription
    if proceed
      @subscriber.make_complimentary!
    else
      flash[:notice] = "Error canceling existing subscription"
    end
    redirect_to customer_edit_redirect
  end
  
  def destroy
    proceed = cancel_braintree_subscription
    if proceed
      @subscriber.cancel_subscription!(:terminate_immediately => true)
    else
      flash[:notice] = "Error canceling existing subscription"
    end
    redirect_to customer_edit_redirect
  end
  
  private
  
  def find_subscriber
    @subscriber = if params[:subscriber_type] == "restaurant"
                  then Restaurant.find(params[:subscriber_id])
                  else User.find(params[:subscriber_id])
                  end
  end
    
  def cancel_braintree_subscription
    return true if (@subscriber.subscription.blank? || @subscriber.subscription.complimentary?)
    result = BraintreeConnector.cancel_subscription(@subscriber.subscription)
    proceed = result.success?
  end
  
  def customer_edit_redirect
    if params[:subscriber_type] == "restaurant"
      edit_admin_restaurant_path(@subscriber)
    else
      edit_admin_user_path(@subscriber)
    end
  end
  
end