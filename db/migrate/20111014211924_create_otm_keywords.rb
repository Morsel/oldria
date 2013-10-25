#encoding: utf-8 
class CreateOtmKeywords < ActiveRecord::Migration
  def self.up
    create_table :otm_keywords do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :otm_keywords
  end
end
