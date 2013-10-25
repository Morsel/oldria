#encoding: utf-8 
class AddNationalToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :national, :boolean
  end

  def self.down
    remove_column :users, :national
  end
end
