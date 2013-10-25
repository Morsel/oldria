#encoding: utf-8 
class AddConfirmedAtToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :confirmed_at, :timestamp
  end

  def self.down
    remove_column :newsletter_subscribers, :confirmed_at
  end
end
