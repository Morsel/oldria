#encoding: utf-8 
class CreateUserVisitorEmailSettings < ActiveRecord::Migration
  def self.up
    create_table :user_visitor_email_settings do |t|
      t.string :email_frequency
      t.string :email_frequency_day
      t.datetime :next_email_at
      t.datetime :last_email_at
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_visitor_email_settings
  end
end
