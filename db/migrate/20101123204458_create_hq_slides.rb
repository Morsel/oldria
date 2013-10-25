#encoding: utf-8 
class CreateHqSlides < ActiveRecord::Migration
  def self.up
    create_table :hq_slides do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :hq_slides
  end
end
