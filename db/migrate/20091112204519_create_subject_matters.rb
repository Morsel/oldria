#encoding: utf-8 
class CreateSubjectMatters < ActiveRecord::Migration
  def self.up
    create_table :subject_matters do |t|
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :subject_matters
  end
end
