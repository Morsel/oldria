#encoding: utf-8 
class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscriptions do |t|
      t.integer :restaurant_id
      t.integer :newsletter_subscriber_id

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_subscriptions
  end
end
