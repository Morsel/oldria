class Subscription < ActiveRecord::Base
  
  belongs_to :subscriber, :polymorphic => true
  belongs_to :payer, :polymorphic => true
  
  def premium?
    true
  end
  
  def complimentary?
    payer.nil?
  end
  
  def active?
    return true if end_date.blank?
    end_date.future?
  end
  
  def in_overtime?
    return false if end_date.blank?
    end_date.future?
  end
  
  def braintree_data
    BraintreeConnector.find_subscription(self)
  end
  
  def set_end_date_from_braintree
    data = braintree_data
    update_attributes(:end_date => data.billing_period_end_date)
  rescue 
    # preventing infinite access if something is weird with braintree 
    # data
    p $!
    update_attributes(:end_date => 1.month.from_now)
  end
  
end

# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer         not null, primary key
#  braintree_id    :string(255)
#  start_date      :date
#  subscriber_id   :integer
#  subscriber_type :string(255)
#  payer_id        :integer
#  payer_type      :string(255)
#  kind            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  end_date        :date
#

