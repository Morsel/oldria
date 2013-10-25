#encoding: utf-8 
class AddLastRequestColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_request_at, :datetime
  end

  def self.down
    remove_column :users, :last_request_at
  end
end
