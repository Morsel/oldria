#encoding: utf-8 
class CreateQuestionRolesOld < ActiveRecord::Migration
  def self.up
    create_table :question_roles do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :question_roles
  end
end
