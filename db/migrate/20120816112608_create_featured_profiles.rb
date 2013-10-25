#encoding: utf-8 
class CreateFeaturedProfiles < ActiveRecord::Migration
  def self.up
    create_table :featured_profiles do |t|
      t.integer :feature_id
      t.string :feature_type
      t.datetime :scheduled_at 
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :spotlight_on,:default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :featured_profiles
  end
end
