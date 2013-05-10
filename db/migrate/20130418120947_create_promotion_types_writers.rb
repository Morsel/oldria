class CreatePromotionTypesWriters < ActiveRecord::Migration
  def self.up
    create_table :promotion_types_writers do |t|
    	t.string  :promotion_writer_type
    	t.integer :promotion_writer_id
      t.integer :user_id
      t.integer :promotion_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion_types_writers
  end
end
