module SubscriptionsControllerHelper
  def billing_history_path(subscriber)
    if(subscriber.is_a? User)
      user_billing_history_path(subscriber)
    elsif(subscriber.is_a? Restaurant)
      restaurant_billing_history_path(subscriber)
    end
  end

  def obscure_credit_card_number(credit_card)
    "...#{h credit_card.last_4}"
  end
end
