#encoding: utf-8 
class AddLastAndNextNewsletterDatestampsToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :last_newsletter_at, :datetime
    add_column :restaurants, :next_newsletter_at, :datetime
    Restaurant.all.each { |r| r.update_attribute(:next_newsletter_at, r.next_newsletter_for_frequency) }
  end

  def self.down
    remove_column :restaurants, :next_newsletter_at
    remove_column :restaurants, :last_newsletter_at
  end
end
