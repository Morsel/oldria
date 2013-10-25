#encoding: utf-8 
class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.integer :promotion_type_id
      t.text :details
      t.string :link
      t.date :start_date
      t.date :end_date
      t.string :date_description

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
