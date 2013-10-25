#encoding: utf-8 
class ChangeUserOnProfileAnswersToPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :profile_answers, :user_id, :responder_id
    add_column :profile_answers, :responder_type, :string

    ProfileAnswer.all.each{ |a| a.update_attribute(:responder_type, 'User') }
  end

  def self.down
    rename_column :profile_answers, :responder_id, :user_id
    remove_column :profile_answers, :responder_type
  end
end
