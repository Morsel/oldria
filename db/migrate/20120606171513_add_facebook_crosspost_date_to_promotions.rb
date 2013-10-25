#encoding: utf-8 
class AddFacebookCrosspostDateToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :post_to_facebook_at, :datetime
  end

  def self.down
    remove_column :promotions, :post_to_facebook_at
  end
end
