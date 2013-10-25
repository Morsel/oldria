#encoding: utf-8 
class AddTwoColumnsToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :newsfeed_writer_id, :integer
  	add_column :users, :digest_writer_id, :integer
  end

  def self.down
  	remove_column :users, :digest_writer_id
  	remove_column :users, :newsfeed_writer_id

  end
end
