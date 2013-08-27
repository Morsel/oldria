class CreateCarteFeatureItems < ActiveRecord::Migration
  def self.up
    create_table :carte_feature_items do |t|
      t.references :item
      t.references :restaurant_feature

      t.timestamps
    end
  end

  def self.down
    drop_table :carte_feature_items
  end
end
