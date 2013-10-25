#encoding: utf-8 
class AddNameToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :first_name, :string
    add_column :newsletter_subscribers, :last_name, :string
  end

  def self.down
    remove_column :newsletter_subscribers, :last_name
    remove_column :newsletter_subscribers, :first_name
  end
end
