#encoding: utf-8 
class BackOutUserPhoneNumbers < ActiveRecord::Migration
  def self.up
    remove_column :users, :phone_number
  end

  def self.down
    add_column :users, :phone_number, :string
  end
end
