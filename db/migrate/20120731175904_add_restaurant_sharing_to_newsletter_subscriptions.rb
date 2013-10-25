#encoding: utf-8 
class AddRestaurantSharingToNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscriptions, :share_with_restaurant, :boolean, :default => false
  end

  def self.down
    remove_column :newsletter_subscriptions, :share_with_restaurant
  end
end
