class Admin::ComplimentaryAccountsController < Admin::AdminController
  
  before_filter :find_subscriber
  
  def create
    subscription = @subscriber.make_complimentary!
    unless subscription
      flash[:notice] = "Error canceling existing subscription"
    end
    redirect_to customer_edit_redirect
  end
  
  #TODO factor so that the cancel is all inside the has_subscription module
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
    return true unless @subscriber.subscription 
    return true if @subscriber.subscription.skip_braintree_cancel?
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