#encoding: utf-8 
class AddCoulmnsToApprenticeships < ActiveRecord::Migration
  def self.up
    add_column :apprenticeships, :start_date, :date
    add_column :apprenticeships, :end_date, :date
    Apprenticeship.all.each do |row|
      row.update_attribute(:start_date, Time.now)
    end
  end

  def self.down
    remove_column :apprenticeships, :end_date
    remove_column :apprenticeships, :start_date
  end
end
