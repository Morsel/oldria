class CreateAdminConversations < ActiveRecord::Migration
  def self.up
    create_table :admin_conversations do |t|
      t.integer :recipient_id
      t.integer :admin_message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_conversations
  end
end
