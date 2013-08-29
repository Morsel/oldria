class CreateKeywordFollowers < ActiveRecord::Migration
  def self.up
    create_table :keyword_followers do |t|
    	t.string  :follow_keyword_type
    	t.integer :follow_keyword_id
      t.integer :user_id


      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_followers
  end
end
