#encoding: utf-8 
class ConvertDefaultEmploymentToSubclass < ActiveRecord::Migration
  def self.up
    add_column :employments, :type, :string
    
    DefaultEmployment.all.each do |e|
      new_e = Employment.new(:employee_id => e.employee_id, :restaurant_role_id => e.restaurant_role_id, 
          :type => "DefaultEmployment")
      puts "Migrated employment #{new_e.id}" if new_e.save!
      e.responsibilities.each { |r| r.update_attribute(:employment_id, new_e.id) }
    end
    
    drop_table :default_employments
    
    remove_column :responsibilities, :default_employment_id
  end

  def self.down
    create_table :default_employments do |t|
      t.integer :employee_id
      t.integer :restaurant_role_id
      t.timestamps
    end
    
    add_column :responsibilities, :default_employment_id, :integer

    Employment.all(:conditions => { :type => "DefaultEmployment" }).each do |e|
      new_e = DefaultEmployment.new(:employee_id => e.employee_id, :restaurant_role_id => e.restaurant_role_id)
      if new_e.save!
        puts "Migrated default employment #{new_e.id}" if new_e.save!
        e.responsibilities.each { |r| r.update_attribute(:default_employment_id, new_e.id) }
      end
    end

    Employment.destroy_all(:restaurant_id => nil)

    remove_column :employments, :type
  end
end
