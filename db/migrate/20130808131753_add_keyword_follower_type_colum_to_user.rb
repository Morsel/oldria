class AddKeywordFollowerTypeColumToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :keyword_follow_type_id ,:integer
  end

  def self.down
  	remove_column :users, :keyword_follow_type_id
  end
end
