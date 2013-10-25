#encoding: utf-8 
class AddAcceptedFlagToHolidayDiscussions < ActiveRecord::Migration
  def self.up
    add_column :holiday_discussions, :accepted, :boolean
  end

  def self.down
    remove_column :holiday_discussions, :accepted
  end
end
