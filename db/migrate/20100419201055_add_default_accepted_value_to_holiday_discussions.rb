#encoding: utf-8 
class AddDefaultAcceptedValueToHolidayDiscussions < ActiveRecord::Migration
  def self.up
    change_column_default :holiday_discussions, :accepted, false
    HolidayDiscussion.all.each { |d| d.update_attribute(:accepted, false) }
  end

  def self.down
    change_column_default :holiday_discussions, :accepted, nil
  end
end
