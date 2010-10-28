module SubscriptionsControllerHelper
  def subscription_path(subscriber)
    if(subscriber.is_a? User)
      user_subscription_path(subscriber)
    elsif(subscriber.is_a? Restaurant)
      restaurant_subscription_path(subscriber)
    end
  end

  def edit_subscription_path(subscriber)
    if(subscriber.is_a? User)
      edit_user_subscription_path(subscriber)
    elsif(subscriber.is_a? Restaurant)
      edit_restaurant_subscription_path(subscriber)
    end
  end

  def new_subscription_path(subscriber)
    if(subscriber.is_a? User)
      new_user_subscription_path(subscriber)
    elsif(subscriber.is_a? Restaurant)
      new_restaurant_subscription_path(subscriber)
    end
  end
  def billing_history_subscription_path(subscriber)
    if(subscriber.is_a? User)
      billing_history_user_subscription_path(subscriber)
    elsif(subscriber.is_a? Restaurant)
      billing_history_restaurant_subscription_path(subscriber)
    end
  end

  def bt_callback_subscription_url(subscriber)
    if(subscriber.is_a? User)
      bt_callback_user_subscription_url(subscriber)
    elsif(subscriber.is_a? Restaurant)
      bt_callback_restaurant_subscription_url(subscriber)
    end
  end

  def customer_edit_path(subscriber)
    if subscriber.is_a? Restaurant
      edit_restaurant_path(subscriber)
    elsif subscriber.is_a? User
      edit_user_path(subscriber)
    end
  end

  def obscure_credit_card_number(credit_card)
    "...#{h credit_card.last_4}"
  end
end
