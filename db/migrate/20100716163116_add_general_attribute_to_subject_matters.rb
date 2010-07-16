class AddGeneralAttributeToSubjectMatters < ActiveRecord::Migration
  def self.up
    add_column :subject_matters, :general, :boolean
  end

  def self.down
    remove_column :subject_matters, :general
  end
end
