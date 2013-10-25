#encoding: utf-8 
class CreateInternships < ActiveRecord::Migration
  def self.up
    create_table :internships do |t|
      t.string :establishment
      t.string :supervisor
      t.date :start_date
      t.date :end_date
      t.text :comments
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :internships
  end
end
