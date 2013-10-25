#encoding: utf-8 
class CreateMenuItemKeywords < ActiveRecord::Migration
  def self.up
    create_table :menu_item_keywords do |t|
      t.integer :menu_item_id
      t.integer :otm_keyword_id

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_item_keywords
  end
end
