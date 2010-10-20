# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer         not null, primary key
#  braintree_id     :string(255)
#  start_date       :date
#  subscriber_id    :integer
#  subscriber_class :string(255)
#  payer_id         :integer
#  payer_class      :string(255)
#  kind             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Subscription < ActiveRecord::Base
  
  belongs_to :subscriber, :polymorphic => true
  belongs_to :payer, :polymorphic => true
  
end
