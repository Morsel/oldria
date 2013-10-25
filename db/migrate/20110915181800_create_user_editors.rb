#encoding: utf-8 
class CreateUserEditors < ActiveRecord::Migration
  def self.up
    create_table :user_editors do |t|
      t.integer :user_id
      t.integer :editor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_editors
  end
end
