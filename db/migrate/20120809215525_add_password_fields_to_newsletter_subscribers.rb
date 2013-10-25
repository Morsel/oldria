#encoding: utf-8 
class AddPasswordFieldsToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :password_hash, :string
    add_column :newsletter_subscribers, :password_salt, :string
  end

  def self.down
    remove_column :newsletter_subscribers, :password_salt
    remove_column :newsletter_subscribers, :password_hash
  end
end
