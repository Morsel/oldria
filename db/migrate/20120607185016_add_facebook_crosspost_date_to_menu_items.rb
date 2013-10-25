#encoding: utf-8 
class AddFacebookCrosspostDateToMenuItems < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :post_to_facebook_at, :datetime
  end

  def self.down
    remove_column :menu_items, :post_to_facebook_at
  end
end
