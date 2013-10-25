#encoding: utf-8 
class CreateQuestionRolesRestaurantRoles < ActiveRecord::Migration
  def self.up
    create_table :question_roles_restaurant_roles, :id => false do |t|
      t.column :question_role_id, :integer
      t.column :restaurant_role_id, :integer
    end
  end

  def self.down
    drop_table :question_roles_restaurant_roles
  end
end
