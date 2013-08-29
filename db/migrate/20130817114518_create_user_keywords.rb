class CreateUserKeywords < ActiveRecord::Migration
  def self.up
    create_table :user_keywords do |t|
    	t.integer :follow_keyword_id
      t.string :follow_keyword_type
      t.integer :user_id
      t.datetime :deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :user_keywords
  end
end
