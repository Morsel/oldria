#encoding: utf-8 
class CreateApprenticeships < ActiveRecord::Migration
  def self.up
    create_table :apprenticeships do |t|
      t.string :establishment
      t.string :supervisor
      t.integer :year
      t.text :comments
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :apprenticeships
  end
end
