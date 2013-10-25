#encoding: utf-8 
class AddUserIdToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :user_id, :integer
  end

  def self.down
    remove_column :newsletter_subscribers, :user_id
  end
end
