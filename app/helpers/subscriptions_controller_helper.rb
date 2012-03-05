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

  def month_options
    [
      ["01 - January", "01"],
      ["02 - February", "02"],
      ["03 - March", "03"],
      ["04 - April", "04"],
      ["05 - May", "05"],
      ["06 - June", "06"],
      ["07 - July", "07"],
      ["08 - August", "08"],
      ["09 - September", "09"],
      ["10 - October", "10"],
      ["11 - November", "11"],
      ["12 - December", "12"]
    ]
  end

  def year_options
    (Date.today.year .. (Date.today.year + 10)).to_a.collect(&:to_s)
  end
end
