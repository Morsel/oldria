#encoding: utf-8 
class DropRoles < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string "role"
    end

    User.all.each do |user|
      if !user.roles.blank?
        user.update_attribute(:role, user.roles.first.name)
      end
    end

    drop_table :roles_users
    drop_table :roles
  end

  def self.down
    change_table :users do |t|
      t.remove :role
    end

    create_table "roles", :force => true do |t|
      t.string   "name",       :limit => 40
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end
  end
end
