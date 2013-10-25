#encoding: utf-8 
class MigrateMediaRequestTypesToSubjectMatters < ActiveRecord::Migration
  def self.up
    add_column :subject_matters, :fields, :string
    add_column :subject_matters, :private, :boolean

    say_with_time "Migrating Media Request Types to Subject Matters" do
      MediaRequestType.all.each do |mrt|
        if SubjectMatter.name_like(mrt.name).blank?
          say "Migrating #{mrt.name}"
          subject_matter = SubjectMatter.create!(:name => mrt.name)
        else
          say "Updating #{mrt.name}"
          subject_matter = SubjectMatter.name_like(mrt.name).first
        end

        SubjectMatter.update_all(['fields = ?', mrt.fields], ["subject_matters.id = ?", subject_matter.id])
      end
    end
  end

  def self.down
    say "Some data may still exist from migrating up. You may need to manually remove some subject matters. \n"

    remove_column :subject_matters, :private
    remove_column :subject_matters, :fields
  end
end
