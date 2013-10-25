#encoding: utf-8 
class AddPairingToMenuItems < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :pairing, :string
  end

  def self.down
    remove_column :menu_items, :pairing
  end
end
