#encoding: utf-8 
class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.string :price

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_items
  end
end
