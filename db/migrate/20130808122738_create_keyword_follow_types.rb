class CreateKeywordFollowTypes < ActiveRecord::Migration
  def self.up
    create_table :keyword_follow_types do |t|
    	t.string :name
      t.timestamps
    end
    KeywordFollowType.create({:name=>"National Writer"})
    KeywordFollowType.create({:name=>"Regional Writer"})
    KeywordFollowType.create({:name=>"Local Writer"})

  end

  def self.down
    drop_table :keyword_follow_types
  end
end
 