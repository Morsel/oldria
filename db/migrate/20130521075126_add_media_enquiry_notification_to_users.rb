#encoding: utf-8 
class AddMediaEnquiryNotificationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :media_inquiries, :boolean, :default => true
    add_column :users, :media_notification, :boolean
  end

  def self.down
    remove_column :users, :media_notification
    remove_column :users, :media_inquiries
  end
end
