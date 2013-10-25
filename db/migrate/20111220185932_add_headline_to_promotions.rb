#encoding: utf-8 
class AddHeadlineToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :headline, :string
  end

  def self.down
    remove_column :promotions, :headline
  end
end
