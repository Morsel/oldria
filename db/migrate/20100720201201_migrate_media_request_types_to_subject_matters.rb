class MigrateMediaRequestTypesToSubjectMatters < ActiveRecord::Migration
  def self.up
    add_column :subject_matters, :fields, :string
    add_column :subject_matters, :private, :boolean

    say_with_time "Migrating Media Request Types to Subject Matters" do
      MediaRequestType.all.each do |mrt|
        SubjectMatter.create!(:fields => mrt.fields, :name => mrt.name)
      end
    end
  end

  def self.down
    say "Some data may still exist from migrating up. You may need to manually remove some subject matters. \n"

    remove_column :subject_matters, :private
    remove_column :subject_matters, :fields
  end
end
