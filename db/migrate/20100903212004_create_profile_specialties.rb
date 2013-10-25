#encoding: utf-8 
class CreateProfileSpecialties < ActiveRecord::Migration
  def self.up
    create_table :profile_specialties do |t|
      t.integer :profile_id
      t.integer :specialty_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_specialties
  end
end
