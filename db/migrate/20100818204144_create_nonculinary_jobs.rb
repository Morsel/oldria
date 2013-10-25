#encoding: utf-8 
class CreateNonculinaryJobs < ActiveRecord::Migration
  def self.up
    create_table :nonculinary_jobs do |t|
      t.integer :profile_id
      t.string :company, :title, :city, :state, :country, :null => false, :default => ""
      t.date :date_started, :null => false
      t.date :date_ended
      t.text :responsibilities, :reason_for_leaving, :null => false, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :nonculinary_jobs
  end
end
