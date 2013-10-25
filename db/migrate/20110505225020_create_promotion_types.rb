#encoding: utf-8 
class CreatePromotionTypes < ActiveRecord::Migration
  def self.up
    create_table :promotion_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion_types
  end
end
