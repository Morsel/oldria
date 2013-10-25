#encoding: utf-8 
class AddUserToProfileAnswers < ActiveRecord::Migration
  def self.up
    add_column :profile_answers, :user_id, :integer
  end

  def self.down
    remove_column :profile_answers, :user_id
  end
end
