class AddWhatsNewWhatsNewNotificationColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :whats_new, :boolean
    add_column :users, :whats_new_notification, :boolean
  end

  def self.down
    remove_column :users, :whats_new_notification
    remove_column :users, :whats_new
  end
end
