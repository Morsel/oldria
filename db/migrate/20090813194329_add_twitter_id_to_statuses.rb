#encoding: utf-8 
class AddTwitterIdToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :twitter_id, :integer
  end

  def self.down
    remove_column :statuses, :twitter_id
  end
end
