#encoding: utf-8 
class AddPerishableTokenToNewsletterSubscriber < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :perishable_token, :string
  end

  def self.down
    remove_column :newsletter_subscribers, :perishable_token
  end
end
