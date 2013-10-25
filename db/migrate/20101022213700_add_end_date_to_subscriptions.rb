#encoding: utf-8 
class AddEndDateToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :end_date, :date
  end

  def self.down
    remove_column :subscriptions, :end_date
  end
end