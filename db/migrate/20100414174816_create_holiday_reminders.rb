#encoding: utf-8 
class CreateHolidayReminders < ActiveRecord::Migration
  def self.up
    create_table :holiday_reminders, :force => true do |t|
      t.datetime :scheduled_at
      t.string :status
      t.text :message
      t.integer :holiday_id
      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_reminders
  end
end
