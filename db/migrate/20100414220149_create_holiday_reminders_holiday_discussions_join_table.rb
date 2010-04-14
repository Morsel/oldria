class CreateHolidayRemindersHolidayDiscussionsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :holiday_discussions_holiday_reminders, :id => false, :force => true do |t|
      t.integer :holiday_discussion_id
      t.integer :holiday_reminder_id
      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_discussions_holiday_reminders
  end
end
