class CreateDaysOfWeeks < ActiveRecord::Migration
  def self.up
    create_table :days_of_weeks do |t|
      t.references :day
      t.references :carte

      t.timestamps
    end
  end

  def self.down
    drop_table :days_of_weeks
  end
end
