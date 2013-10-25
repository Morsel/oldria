#encoding: utf-8 
class AddOptOutToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :opt_out, :boolean, :default => false
  end

  def self.down
    remove_column :newsletter_subscribers, :opt_out
  end
end
