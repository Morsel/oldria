class Admin::ComplimentaryAccountsController < Admin::AdminController
  
  before_filter :find_subscriber
  
  def create
    subscription = @subscriber.make_complimentary!
    unless subscription
      flash[:notice] = "Error canceling existing subscription"
    end
    redirect_to customer_edit_redirect
  end
  
  def destroy
    unless @subscriber.admin_cancel
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
  
  def customer_edit_redirect
    if params[:subscriber_type] == "restaurant"
      edit_admin_restaurant_path(@subscriber)
    else
      edit_admin_user_path(@subscriber)
    end
  end
  
end