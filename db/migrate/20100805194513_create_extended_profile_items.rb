class CreateExtendedProfileItems < ActiveRecord::Migration
  def self.up
    create_table :extended_profile_items do |t|
      t.integer :profile_id
      t.string :category
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :extended_profile_items
  end
end
