#encoding: utf-8 
class RenameAcheivementsToAchievementsOnNonculinaryEnrollments < ActiveRecord::Migration
  def self.up
    rename_column :nonculinary_enrollments, :acheivements, :achievements
  end

  def self.down
    rename_column :nonculinary_enrollments, :achievements, :acheivements
  end
end
