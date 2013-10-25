#encoding: utf-8 
class CreateInvitedEmployees < ActiveRecord::Migration
  def self.up
    create_table :invited_employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :invited_employees
  end
end
