#encoding: utf-8 
class AddTwitterCrosspostDateToMenuItems < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :post_to_twitter_at, :datetime
  end

  def self.down
    remove_column :menu_items, :post_to_twitter_at
  end
end
