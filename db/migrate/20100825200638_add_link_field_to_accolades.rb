#encoding: utf-8 
class AddLinkFieldToAccolades < ActiveRecord::Migration
  def self.up
    add_column :accolades, :link, :string
  end

  def self.down
    remove_column :accolades, :link
  end
end
