#encoding: utf-8 
class CreateVisitorEmailSettings < ActiveRecord::Migration
  def self.up
    create_table :visitor_email_settings do |t|
    	t.integer :restaurant_id
    	t.boolean :is_approved ,:default =>false
    	t.string  :email_frequency, :default => "Daily"
    	t.string  :email_frequency_day
    	t.datetime :next_email_at, :default => Time.now
      t.datetime :last_email_at, :default => DateTime.yesterday.to_datetime

      t.timestamps
    end
    Restaurant.all.each do |restaurant|
    	restaurant.build_visitor_email_setting.save
    end	
  end

  def self.down
    drop_table :visitor_email_settings
  end
end
