#encoding: utf-8 
class CreateAdminMessages < ActiveRecord::Migration
  def self.up
    create_table :admin_messages do |t|
      t.string :type
      t.datetime :sent_at
      t.string :status
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_messages
  end
end
