#encoding: utf-8 
class RenameCulinarySchoolsToSchools < ActiveRecord::Migration
  def self.up
    rename_table :culinary_schools, :schools

    change_table :schools do |t|
      t.boolean :culinary
    end

    rename_column :enrollments, :culinary_school_id, :school_id
  end

  def self.down
    rename_column :enrollments, :school_id, :culinary_school_id

    change_table :schools do |t|
      t.remove :culinary
    end

    rename_table :schools, :culinary_schools
  end
end
