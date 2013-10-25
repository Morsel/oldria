#encoding: utf-8 
class AddDueDateToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :due_date, :date
  end

  def self.down
    remove_column :media_requests, :due_date
  end
end
