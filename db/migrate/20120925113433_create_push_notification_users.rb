#encoding: utf-8 
class CreatePushNotificationUsers < ActiveRecord::Migration
  def self.up
    create_table :push_notification_users do |t|
      t.string :device_tocken
      t.string :uniq_device_key
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :push_notification_users
  end
end
