#encoding: utf-8 
class AddHolidayToAdminMessages < ActiveRecord::Migration
  def self.up
    add_column :admin_messages, :holiday_id, :integer
  end

  def self.down
    remove_column :admin_messages, :holiday_id
  end
end
