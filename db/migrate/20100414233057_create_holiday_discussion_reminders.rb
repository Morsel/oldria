#encoding: utf-8 
class CreateHolidayDiscussionReminders < ActiveRecord::Migration
  def self.up
    create_table :holiday_discussion_reminders do |t|
      t.integer :holiday_discussion_id
      t.integer :holiday_reminder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_discussion_reminders
  end
end
