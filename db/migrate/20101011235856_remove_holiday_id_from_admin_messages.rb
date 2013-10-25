#encoding: utf-8 
class RemoveHolidayIdFromAdminMessages < ActiveRecord::Migration
  def self.up
    remove_column :admin_messages, :holiday_id
  end

  def self.down
    add_column :admin_messages, :holiday_id, :integer
  end
end
