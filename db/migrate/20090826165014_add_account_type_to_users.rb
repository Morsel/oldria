#encoding: utf-8 
class AddAccountTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_type_id, :integer
  end

  def self.down
    remove_column :users, :account_type_id
  end
end
