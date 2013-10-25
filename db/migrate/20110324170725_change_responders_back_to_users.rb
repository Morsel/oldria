#encoding: utf-8 
class ChangeRespondersBackToUsers < ActiveRecord::Migration
  def self.up
    rename_column :question_roles, :responder_id, :restaurant_role_id
    remove_column :question_roles, :responder_type

    rename_column :profile_answers, :responder_id, :user_id
    remove_column :profile_answers, :responder_type
  end

  def self.down
    add_column :question_roles, :responder_type, :string
    rename_column :question_roles, :restaurant_role_id, :responder_id

    add_column :profile_answers, :responder_type, :string
    rename_column :profile_answers, :user_id, :responder_id
  end
end
