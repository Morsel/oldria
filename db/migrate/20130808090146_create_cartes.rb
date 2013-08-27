class CreateCartes < ActiveRecord::Migration
  def self.up
    create_table :cartes do |t|
      t.string :name
      t.string :description
      t.time :start_time
      t.time :end_time
      t.datetime :start_date
      t.datetime :end_date
      t.string :note
      t.references :restaurant

      t.timestamps
    end
  end

  def self.down
    drop_table :cartes
  end
end
