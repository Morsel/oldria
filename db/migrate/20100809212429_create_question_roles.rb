class CreateQuestionRoles < ActiveRecord::Migration
  def self.up
    create_table :question_roles do |t|
      t.string :name
      t.string :restaurant_role_ids

      t.timestamps
    end
  end

  def self.down
    drop_table :question_roles
  end
end
