class AddBillingPeriodEndDateToSubscription < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :billing_period_end_date, :date
    add_column :subscriptions, :billing_period_start_date, :date
    add_column :subscriptions, :current_billing_cycle, :integer
    add_column :subscriptions, :paid_through_date, :date
    add_column :subscriptions, :next_billing_date, :date
    add_column :subscriptions, :first_billing_date, :date
    add_column :subscriptions, :failure_count, :integer
  end

  def self.down
    remove_column :subscriptions, :billing_period_end_date
    remove_column :subscriptions, :billing_period_start_date
    remove_column :subscriptions, :current_billing_cycle
    remove_column :subscriptions, :paid_through_date
    remove_column :subscriptions, :next_billing_date
    remove_column :subscriptions, :first_billing_date
    remove_column :subscriptions, :failure_count
  end
end
