#encoding: utf-8 
class RemovePublicFlagFromAlmAnswers < ActiveRecord::Migration
  def self.up
    remove_column :a_la_minute_answers, :show_as_public
  end

  def self.down
    add_column :a_la_minute_answers, :show_as_public, :boolean, :default => true
  end
end
