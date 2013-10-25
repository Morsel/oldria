#encoding: utf-8 
class CreateResponsibilities < ActiveRecord::Migration
  def self.up
    create_table :responsibilities do |t|
      t.integer :employment_id
      t.integer :subject_matter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :responsibilities
  end
end
