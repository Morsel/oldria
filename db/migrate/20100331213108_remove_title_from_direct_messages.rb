#encoding: utf-8 
class RemoveTitleFromDirectMessages < ActiveRecord::Migration
  def self.up
    remove_column :direct_messages, :title
  end

  def self.down
    add_column :direct_messages, :title, :string
  end
end
