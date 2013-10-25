#encoding: utf-8 
class AddGeneralAttributeToSubjectMatters < ActiveRecord::Migration
  def self.up
    add_column :subject_matters, :general, :boolean
    say_with_time "Migrating Subject Matters to general" do
      SubjectMatter.all.each do |sm|
        sm.update_attribute :general, true
      end
    end
  end

  def self.down
    remove_column :subject_matters, :general
  end
end
