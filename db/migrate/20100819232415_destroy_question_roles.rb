#encoding: utf-8 
class DestroyQuestionRoles < ActiveRecord::Migration
  def self.up
    drop_table :question_roles
    drop_table :question_roles_topics
    drop_table :question_roles_restaurant_roles
  end

  def self.down
    create_table :question_roles do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :question_roles_topics, :id => false do |t|
      t.column :question_role_id, :integer
      t.column :topic_id, :integer
    end
    
    create_table :question_roles_restaurant_roles, :id => false do |t|
      t.column :question_role_id, :integer
      t.column :restaurant_role_id, :integer
    end
  end
end
