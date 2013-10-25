#encoding: utf-8 
class CreateRestaurantNewsletters < ActiveRecord::Migration
  def self.up
    create_table :restaurant_newsletters do |t|
      t.column "restaurant_id", :integer
      t.column "menu_item_ids", :text
      t.column "restaurant_answer_ids", :text
      t.column "menu_ids", :text
      t.column "promotion_ids", :text
      t.column "a_la_minute_answer_ids", :text      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_newsletters
  end
end
