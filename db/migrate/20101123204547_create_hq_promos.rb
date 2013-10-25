#encoding: utf-8 
class CreateHqPromos < ActiveRecord::Migration
  def self.up
    create_table :hq_promos do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :hq_promos
  end
end
