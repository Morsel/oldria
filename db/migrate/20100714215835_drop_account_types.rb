#encoding: utf-8 
class DropAccountTypes < ActiveRecord::Migration
  def self.up
    drop_table :account_types
    remove_column :users, :account_type_id
  end

  def self.down
    create_table :account_types, :force => true do |t|
      t.string   :name
      t.timestamps
    end
    add_column :users, :account_type_id, :integer
  end
end
