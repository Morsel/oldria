#encoding: utf-8 
class AddFbPageToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_page_id, :integer
    add_column :users, :facebook_page_token, :string
  end

  def self.down
    remove_column :users, :facebook_page_token
    remove_column :users, :facebook_page_id
  end
end
