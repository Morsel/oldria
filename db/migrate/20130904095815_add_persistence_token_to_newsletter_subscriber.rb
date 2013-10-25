#encoding: utf-8 
class AddPersistenceTokenToNewsletterSubscriber < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :persistence_token, :string
  end

  def self.down
    remove_column :newsletter_subscribers, :persistence_token
  end
end
