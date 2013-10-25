#encoding: utf-8 
class AddTwitterCrosspostDateToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :post_to_twitter_at, :datetime
  end

  def self.down
    remove_column :promotions, :post_to_twitter_at
  end
end
