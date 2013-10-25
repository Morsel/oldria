#encoding: utf-8 
class CreateQuestionRolesTopics < ActiveRecord::Migration
  def self.up
    create_table :question_roles_topics, :id => false do |t|
      t.column :question_role_id, :integer
      t.column :topic_id, :integer
    end
  end

  def self.down
    drop_table :question_roles_topics
  end
end
