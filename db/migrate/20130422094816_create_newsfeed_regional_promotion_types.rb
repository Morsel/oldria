#encoding: utf-8 
class CreateNewsfeedRegionalPromotionTypes < ActiveRecord::Migration
  def self.up
    create_table :newsfeed_regional_promotion_types do |t|
    	t.integer :promotion_type_id
    	t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :newsfeed_regional_promotion_types
  end
end
