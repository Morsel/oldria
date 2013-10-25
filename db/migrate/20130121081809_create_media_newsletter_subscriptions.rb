#encoding: utf-8 
class CreateMediaNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :media_newsletter_subscriptions do |t|
      t.integer :restaurant_id
      t.integer :media_newsletter_subscriber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :media_newsletter_subscriptions
  end
end
