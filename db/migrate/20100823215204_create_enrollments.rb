#encoding: utf-8 
class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.references :culinary_school, :null => false
      t.references :profile, :null => false
      t.date :graduation_date
      t.string :degree, :default => '', :null => false
      t.text :focus, :scholarships

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
