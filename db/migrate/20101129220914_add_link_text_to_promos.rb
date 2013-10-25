#encoding: utf-8 
class AddLinkTextToPromos < ActiveRecord::Migration
  def self.up
    add_column :promos, :link_text, :string
  end

  def self.down
    remove_column :promos, :link_text
  end
end
