# == Schema Information
# Schema version: 20120217190417
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
#  status          :string(255)
#

class Subscription < ActiveRecord::Base

  module Status
    PAST_DUE = "past_due"
  end

  belongs_to :subscriber, :polymorphic => true
  belongs_to :payer, :polymorphic => true

  scope :user_subscriptions, :conditions => {:subscriber_type => "User"}
  scope :is_active, lambda {
    { :conditions => ['end_date is NULL OR end_date >= ?', Time.now] }
  }
  attr_accessible :kind, :payer, :start_date, :braintree_id, :end_date
  def premium?
    true
  end

  def has_braintree_info?
    braintree_id.present?
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

  def staff_account?
    payer && payer.can_be_payer? && subscriber.can_be_staff?
  end

  def braintree_data
    BraintreeConnector.find_subscription(self)
  end

  def calculate_end_date
    return 1.month_from_now unless has_braintree_info?
    data = braintree_data
    data.billing_period_end_date
  rescue
    1.month.from_now
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

  def past_due!
    update_attributes(:status => Subscription::Status::PAST_DUE, :end_date => 5.days.from_now.to_date)
  end

  def self.purge_expired!
    destroy_all("status = '#{Subscription::Status::PAST_DUE}' AND end_date < '#{Date.today.to_date}'")
  end

  def skip_braintree_cancel?
    complimentary? || in_overtime?
  end

  def add_staff_account(user)
    return unless subscriber.can_be_payer?
    return unless user.can_be_staff?
    return if !active?
    result = BraintreeConnector.set_add_ons_for_subscription(self,
        user_subscriptions_for_payer.size + 1)
    if result.success?
      user.make_staff_account!(subscriber)
      subscriber.subscription
    else
      nil
    end
  end

  def remove_staff_account(user)
    return unless subscriber.can_be_payer?
    return unless user.can_be_staff?
    return if !active?
    result = BraintreeConnector.set_add_ons_for_subscription(self,
        user_subscriptions_for_payer.size - 1)
    if result.success?
      user.cancel_subscription!(:terminate_immediately => true)
      self
    else
      nil
    end
  end

  def user_subscriptions_for_payer
    if payer
      payer.paid_subscriptions.user_subscriptions
    else
      subscriber.paid_subscriptions.user_subscriptions
    end
  end

end
