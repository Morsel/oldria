#encoding: utf-8 
class AddPublicationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :publication, :string
  end

  def self.down
    remove_column :users, :publication
  end
end
