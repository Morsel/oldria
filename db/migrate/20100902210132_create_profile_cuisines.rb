#encoding: utf-8 
class CreateProfileCuisines < ActiveRecord::Migration
  def self.up
    create_table :profile_cuisines do |t|
      t.integer :profile_id
      t.integer :cuisine_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_cuisines
  end
end
