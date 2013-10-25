#encoding: utf-8 
class ConvertFacebookIdsToStrings < ActiveRecord::Migration
  def self.up
    change_column :users, :facebook_id, :string
    change_column :users, :facebook_page_id, :string
  end

  def self.down
    change_column :users, :facebook_page_id, :integer
    change_column :users, :facebook_id, :integer
  end
end
