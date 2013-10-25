#encoding: utf-8 
class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :braintree_id
      t.date :start_date
      t.integer :subscriber_id
      t.string :subscriber_type
      t.integer :payer_id
      t.string :payer_type
      t.string :kind
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
