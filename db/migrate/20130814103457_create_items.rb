class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
    	t.string :name
      t.string :description
      t.string :options
      t.integer :price
      t.string :add_on
      t.integer :add_on_price
      t.string :note
      t.references :category

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
