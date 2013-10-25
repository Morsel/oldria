#encoding: utf-8 
class CreateNonculinaryEnrollments < ActiveRecord::Migration
  def self.up
    create_table :nonculinary_enrollments do |t|
      t.references :nonculinary_school, :profile
      t.date :graduation_date
      t.string :field_of_study, :degree
      t.text :acheivements

      t.timestamps
    end
  end

  def self.down
    drop_table :nonculinary_enrollments
  end
end
