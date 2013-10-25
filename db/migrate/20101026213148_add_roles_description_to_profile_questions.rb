#encoding: utf-8 
class AddRolesDescriptionToProfileQuestions < ActiveRecord::Migration
  def self.up
    add_column :profile_questions, :roles_description, :text
    ProfileQuestion.all.each(&:touch)
  end

  def self.down
    remove_column :profile_questions, :roles_description
  end
end
