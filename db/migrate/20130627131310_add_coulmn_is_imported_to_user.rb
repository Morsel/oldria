#encoding: utf-8 
class AddCoulmnIsImportedToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :is_imported, :boolean,:default =>false
  end

  def self.down
  	remove_column :users, :is_imported
  end
end
