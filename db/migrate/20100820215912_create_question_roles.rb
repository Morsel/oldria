#encoding: utf-8 
class CreateQuestionRoles < ActiveRecord::Migration
  def self.up
    create_table :question_roles do |t|
      t.integer :profile_question_id
      t.integer :restaurant_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :question_roles
  end
end
